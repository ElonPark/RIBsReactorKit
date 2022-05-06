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

/// @mockable
protocol UserListRouting: ViewableRouting {
  func attachUserInformationRIB()
  func detachUserInformationRIB()
}

// MARK: - UserListPresentable

protocol UserListPresentable: Presentable {
  var listener: UserListPresentableListener? { get set }
}

// MARK: - UserListListener

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
    case setLoading(Bool)
    case setRefresh(Bool)
    case userListSections([UserListSectionModel])
    case attachUserInformationRIB
  }

  // MARK: - Properties

  weak var router: UserListRouting?
  weak var listener: UserListListener?

  let initialState: UserListPresentableState

  private let randomUserRepositoryService: RandomUserRepositoryService
  private let userModelDataStream: UserModelDataStream
  private let mutableSelectedUserModelStream: MutableSelectedUserModelStream

  private let imagePrefetchWorker: ImagePrefetchWorking

  private let requestItemCount: Int = 50

  // MARK: - Initialization & Deinitialization

  init(
    presenter: UserListPresentable,
    initialState: UserListPresentableState,
    randomUserRepositoryService: RandomUserRepositoryService,
    userModelDataStream: UserModelDataStream,
    mutableSelectedUserModelStream: MutableSelectedUserModelStream,
    imagePrefetchWorker: ImagePrefetchWorking
  ) {
    self.initialState = initialState
    self.randomUserRepositoryService = randomUserRepositoryService
    self.userModelDataStream = userModelDataStream
    self.mutableSelectedUserModelStream = mutableSelectedUserModelStream
    self.imagePrefetchWorker = imagePrefetchWorker

    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    self.imagePrefetchWorker.start(self)
  }

  // MARK: - UserListPresentableListener

  func sendAction(_ action: Action) {
    self.action.on(.next(action))
  }
}

// MARK: - mutate

extension UserListInteractor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return self.loadDataMutation()

    case .refresh:
      return self.refreshMutation()

    case let .loadMore(indexPath):
      return self.loadMoreMutation(withCurrentItemIndexPath: indexPath)

    case let .prefetchItems(indexPath):
      return self.prefetchItemsMutation(withItemIndexPaths: indexPath)

    case let .itemSelected(indexPath):
      return self.itemSelectedMutation(bySelectedItemIndexPath: indexPath)
    }
  }

  private func loadDataMutation() -> Observable<Mutation> {
    let needLoadingData = currentState.userListSections.first?.items.contains(.dummy) ?? true
    guard needLoadingData else { return .empty() }

    return self.refreshMutation()
  }

  private func refreshMutation() -> Observable<Mutation> {
    let loadDataMutation: Observable<Mutation> = self.randomUserRepositoryService
      .loadData(isRefresh: true, itemCount: self.requestItemCount)
      .flatMap { Observable.empty() }
      .catchAndReturn(.setRefresh(false))

    let sequence: [Observable<Mutation>] = [
      .just(.setRefresh(true)),
      loadDataMutation,
      .just(.setRefresh(false))
    ]

    return .concat(sequence)
  }

  private func loadMoreMutation(withCurrentItemIndexPath indexPath: IndexPath) -> Observable<Mutation> {
    let lastSectionNumber = currentState.userListSections.count - 1
    guard indexPath.section == lastSectionNumber else { return .empty() }

    let lastItemRow = currentState.userListSections[indexPath.section].items.count - 1
    guard indexPath.row == lastItemRow else { return .empty() }

    return self.randomUserRepositoryService
      .loadData(isRefresh: false, itemCount: self.requestItemCount)
      .flatMap { Observable.empty() }
      .catchAndReturn(.setRefresh(false))
  }

  private func prefetchItemsMutation(withItemIndexPaths indexPaths: [IndexPath]) -> Observable<Mutation> {
    let urls = indexPaths
      .compactMap { currentState.userListSections[safe: $0.section]?.items[safe: $0.row] }
      .compactMap { item -> URL? in
        guard case let .user(viewModel) = item else { return nil }
        return viewModel.profileImageURL
      }

    self.imagePrefetchWorker.startPrefetch(withURLs: urls)
    return .empty()
  }

  private func itemSelectedMutation(bySelectedItemIndexPath indexPath: IndexPath) -> Observable<Mutation> {
    let sections = currentState.userListSections
    let section = sections[safe: indexPath.section]
    guard let item = section?.items[safe: indexPath.row] else { return .empty() }

    switch item {
    case let .user(viewModel):
      guard let user = userModelDataStream.userModel(byUUID: viewModel.uuid) else { return .empty() }
      self.mutableSelectedUserModelStream.updateSelectedUserModel(by: user)
      return .just(.attachUserInformationRIB)

    case .dummy:
      return .empty()
    }
  }
}

// MARK: - transform mutation

extension UserListInteractor {
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return .merge(mutation, self.updateUserModelsTransform())
      .withUnretained(self)
      .flatMap { this, mutation -> Observable<Mutation> in
        switch mutation {
        case .attachUserInformationRIB:
          return this.attachUserInformationRIBTransform()

        default:
          return .just(mutation)
        }
      }
  }

  private func updateUserModelsTransform() -> Observable<Mutation> {
    return self.userModelDataStream.userModels
      .filter { !$0.isEmpty }
      .distinctUntilChanged()
      .map { $0.map(UserListItemViewModel.init) }
      .map { $0.map(UserListSectionItem.user) }
      .map { [UserListSectionModel.randomUser($0)] }
      .map(Mutation.userListSections)
  }

  /// Show selected user information
  private func attachUserInformationRIBTransform() -> Observable<Mutation> {
    self.router?.attachUserInformationRIB()
    return .empty()
  }
}

// MARK: - reduce

extension UserListInteractor {
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setRefresh(isRefresh):
      newState.isRefresh = isRefresh

    case let .userListSections(sections):
      newState.userListSections = sections

    case .attachUserInformationRIB:
      Log.debug("Do Nothing when \(mutation)")
    }

    return newState
  }
}

// MARK: - UserInformationListener

extension UserListInteractor {
  func detachUserInformationRIB() {
    self.router?.detachUserInformationRIB()
  }
}
