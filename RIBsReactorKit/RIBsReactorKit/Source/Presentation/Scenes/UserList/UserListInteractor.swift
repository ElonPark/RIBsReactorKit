//
//  UserListInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import ReactorKit
import RIBs
import RxSwift

// MARK: - UserListRouting

protocol UserListRouting: ViewableRouting {
  func attachUserInformationRIB()
  func detachUserInformationRIB()
}

// MARK: - UserListPresentable

protocol UserListPresentable: Presentable {
  var listener: UserListPresentableListener? { get set }
}

protocol UserListListener: AnyObject {}

// MARK: - UserListInteractor

final class UserListInteractor:
  PresentableInteractor<UserListPresentable>,
  UserListInteractable,
  UserListPresentableListener,
  Reactor
{

  // MARK: - Reactor

  typealias Action = UserListPresentableAction
  typealias State = UserListPresentableState

  enum Mutation {
    case loadData
    case setLoading(Bool)
    case setRefresh(Bool)
    case userListSections([UserListSectionModel])
    case selectedUser(UserModel)
  }

  // MARK: - Properties

  weak var router: UserListRouting?
  weak var listener: UserListListener?

  let initialState: UserListPresentableState

  private let randomUserUseCase: RandomUserUseCase
  private let userModelDataStream: UserModelDataStream
  private let mutableSelectedUserModelStream: MutableSelectedUserModelStream

  private let requestItemCount: Int = 50

  // MARK: - Initialization & Deinitialization

  init(
    initialState: UserListPresentableState,
    randomUserUseCase: RandomUserUseCase,
    userModelDataStream: UserModelDataStream,
    mutableSelectedUserModelStream: MutableSelectedUserModelStream,
    presenter: UserListPresentable
  ) {
    self.initialState = initialState
    self.randomUserUseCase = randomUserUseCase
    self.userModelDataStream = userModelDataStream
    self.mutableSelectedUserModelStream = mutableSelectedUserModelStream

    super.init(presenter: presenter)
    presenter.listener = self
  }
}

// MARK: - Reactor

extension UserListInteractor {

  func sendAction(_ action: Action) {
    self.action.on(.next(action))
  }

  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return refreshMutation()

    case .refresh:
      return refreshMutation()

    case let .loadMore(indexPath):
      return loadMoreMutation(by: indexPath)

    case let .itemSelected(indexPath):
      return itemSelectedMutation(by: indexPath)
    }
  }

  private func refreshMutation() -> Observable<Mutation> {
    let loadData: Observable<Mutation> = randomUserUseCase
      .loadData(isRefresh: true, itemCount: requestItemCount)
      .map { .loadData }
      .catchAndReturn(.setRefresh(false))

    let sequence: [Observable<Mutation>] = [
      .just(Mutation.setRefresh(true)),
      loadData,
      .just(Mutation.setRefresh(false))
    ]

    return .concat(sequence)
  }

  private func loadMoreMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let lastSectionNumber = currentState.userListSections.count - 1
    guard indexPath.section == lastSectionNumber else { return .empty() }

    let lastItemRow = currentState.userListSections[indexPath.section].items.count - 1
    guard indexPath.row == lastItemRow else { return .empty() }

    return randomUserUseCase.loadData(isRefresh: false, itemCount: requestItemCount)
      .map { Mutation.loadData }
      .catchAndReturn(.setRefresh(false))
  }

  private func itemSelectedMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let sections = currentState.userListSections
    let section = sections[safe: indexPath.section]
    guard let item = section?.items[safe: indexPath.row] else { return .empty() }

    switch item {
    case let .user(viewModel):
      guard let user = userModelDataStream.userModel(byUUID: viewModel.uuid) else { return .empty() }
      return .just(.selectedUser(user))

    case .dummy:
      return .empty()
    }
  }

  // MARK: - transform mutation

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .withUnretained(self)
      .flatMap { this, mutation -> Observable<Mutation> in
        switch mutation {
        case .loadData:
          return this.updateUserModelsTransform()

        case let .selectedUser(userModel):
          return this.selectedUserTransform(by: userModel)

        default:
          return .just(mutation)
        }
      }
  }

  /// mutableUserModelsStream is update userModels when trigger Action
  /// (.loadData, .refresh, .loadMore)
  private func updateUserModelsTransform() -> Observable<Mutation> {
    return userModelDataStream.userModels
      .distinctUntilChanged()
      .map { $0.map(UserListItemViewModel.init) }
      .map { $0.map(UserListSectionItem.user) }
      .map { [UserListSectionModel.randomUser($0)] }
      .map(Mutation.userListSections)
  }

  /// Show selected user information
  private func selectedUserTransform(by userModel: UserModel) -> Observable<Mutation> {
    mutableSelectedUserModelStream.updateSelectedUserModel(by: userModel)
    router?.attachUserInformationRIB()
    return .empty()
  }

  // MARK: - reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setRefresh(isRefesh):
      newState.isRefresh = isRefesh

    case let .userListSections(sections):
      newState.userListSections = sections

    case .loadData, .selectedUser:
      Log.debug("Do Nothing when \(mutation)")
    }

    return newState
  }
}

// MARK: - UserInformationAdapterListener

extension UserListInteractor {
  func detachUserInformationRIB() {
    router?.detachUserInformationRIB()
  }
}
