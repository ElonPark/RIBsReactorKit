//
//  UserCollectionInteractor.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import ReactorKit
import RIBs
import RxSwift

// MARK: - UserCollectionRouting

protocol UserCollectionRouting: ViewableRouting {
  func attachUserInformationRIB()
  func detachUserInformationRIB()
}

// MARK: - UserCollectionPresentable

protocol UserCollectionPresentable: Presentable {
  var listener: UserCollectionPresentableListener? { get set }
}

// MARK: - UserCollectionListener

protocol UserCollectionListener: AnyObject {}

// MARK: - UserCollectionInteractorDependency

protocol UserCollectionInteractorDependency {
  var initialState: UserCollectionState { get }
  var randomUserRepositoryService: RandomUserRepositoryService { get }
  var userModelDataStream: UserModelDataStream { get }
  var mutableSelectedUserModelStream: MutableSelectedUserModelStream { get }
  var imagePrefetchWorker: ImagePrefetchWorking { get }
}

// MARK: - UserCollectionInteractor

final class UserCollectionInteractor:
  PresentableInteractor<UserCollectionPresentable>,
  UserCollectionInteractable,
  UserCollectionPresentableListener,
  Reactor
{

  // MARK: - Reactor

  typealias Action = UserCollectionAction
  typealias State = UserCollectionState

  enum Mutation {
    case setLoading(Bool)
    case setRefresh(Bool)
    case setUserModels([UserModel])
    case attachUserInformationRIB
  }

  // MARK: - Properties

  weak var router: UserCollectionRouting?
  weak var listener: UserCollectionListener?

  let initialState: UserCollectionState
  let requestItemCount: Int = 50

  private let dependency: UserCollectionInteractorDependency

  init(
    presenter: UserCollectionPresentable,
    dependency: UserCollectionInteractorDependency
  ) {
    self.dependency = dependency
    self.initialState = self.dependency.initialState
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    dependency.imagePrefetchWorker.start(self)
  }

  // MARK: - UserCollectionPresentableListener

  func sendAction(_ action: Action) {
    self.action.on(.next(action))
  }
}

// MARK: - mutate

extension UserCollectionInteractor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return loadDataMutation()

    case .refresh:
      return refreshMutation()

    case let .loadMore(indexPath):
      return loadMoreMutation(withCurrentItemIndex: indexPath)

    case let .prefetchResource(itemURLs):
      return prefetchResourceMutation(withItemURLs: itemURLs)

    case let .itemSelected(indexPath):
      return itemSelectedMutation(bySelectedItemIndex: indexPath)
    }
  }

  private func loadDataMutation() -> Observable<Mutation> {
    guard !currentState.isLoading && currentState.userModels.isEmpty else { return .empty() }

    let loadDataMutation: Observable<Mutation> = dependency.randomUserRepositoryService
      .loadData(isRefresh: false, itemCount: requestItemCount)
      .flatMap { Observable.empty() }
      .catchAndReturn(.setLoading(false))

    let sequence: [Observable<Mutation>] = [
      .just(.setLoading(true)),
      loadDataMutation,
      .just(.setLoading(false))
    ]

    return .concat(sequence)
  }

  private func refreshMutation() -> Observable<Mutation> {
    let refreshDataMutation: Observable<Mutation> = dependency.randomUserRepositoryService
      .loadData(isRefresh: true, itemCount: requestItemCount)
      .flatMap { Observable.empty() }
      .catchAndReturn(.setRefresh(false))

    let sequence: [Observable<Mutation>] = [
      .just(.setRefresh(true)),
      refreshDataMutation,
      .just(.setRefresh(false))
    ]

    return .concat(sequence)
  }

  private func loadMoreMutation(withCurrentItemIndex currentItemIndex: Int) -> Observable<Mutation> {
    let userModelCount = currentState.userModels.count
    let lastIndex = userModelCount - 1
    guard userModelCount >= requestItemCount && currentItemIndex == lastIndex else { return .empty() }

    return dependency.randomUserRepositoryService
      .loadData(isRefresh: false, itemCount: requestItemCount)
      .flatMap { Observable.empty() }
      .catchAndReturn(.setRefresh(false))
  }

  private func prefetchResourceMutation(withItemURLs urls: [URL]) -> Observable<Mutation> {
    dependency.imagePrefetchWorker.startPrefetch(withURLs: urls)
    return .empty()
  }

  private func itemSelectedMutation(bySelectedItemIndex itemIndex: Int) -> Observable<Mutation> {
    guard let item = currentState.userModels[safe: itemIndex] else { return .empty() }
    guard let user = dependency.userModelDataStream.userModel(byUUID: item.uuid) else { return .empty() }

    dependency.mutableSelectedUserModelStream.updateSelectedUserModel(by: user)
    return .just(.attachUserInformationRIB)
  }
}

// MARK: - transform mutation

extension UserCollectionInteractor {
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return .merge(mutation, updateUserModelsTransform())
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
    return dependency.userModelDataStream.userModels
      .filter { !$0.isEmpty }
      .distinctUntilChanged()
      .map(Mutation.setUserModels)
  }

  /// Show selected user information
  private func attachUserInformationRIBTransform() -> Observable<Mutation> {
    router?.attachUserInformationRIB()
    return .empty()
  }
}

// MARK: - reduce

extension UserCollectionInteractor {
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setRefresh(isRefresh):
      newState.isRefresh = isRefresh

    case let .setUserModels(userModels):
      newState.userModels = userModels

    case .attachUserInformationRIB:
      Log.debug("Do Nothing when \(mutation)")
    }

    return newState
  }
}

// MARK: - UserInformationListener

extension UserCollectionInteractor {
  func detachUserInformationRIB() {
    router?.detachUserInformationRIB()
  }
}
