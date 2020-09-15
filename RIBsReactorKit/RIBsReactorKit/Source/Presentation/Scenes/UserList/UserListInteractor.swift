//
//  UserListInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import ReactorKit
import RxSwift
import RxSwiftExt

protocol UserListRouting: ViewableRouting {
  func attachUserInfomationRIB(with userModel: UserModel)
  func detachUserInfomationRIB()
}

protocol UserListPresentable: Presentable {
  var listener: UserListPresentableListener? { get set }
}

protocol UserListListener: class {}

final class UserListInteractor:
  PresentableInteractor<UserListPresentable>,
  UserListInteractable,
  UserListPresentableListener,
  Reactor
{
  
  // MARK: - Constants
  
  typealias Action = UserListPresentableAction
  typealias State = UserListPresentableState
  
  enum Mutation: Equatable {
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
  
  // MARK: - Initialization & Deinitialization

  init(
    initialState: UserListPresentableState,
    randomUserUseCase: RandomUserUseCase,
    presenter: UserListPresentable
  ) {
    self.initialState = initialState
    self.randomUserUseCase = randomUserUseCase
    
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  // MARK: - Inheritance

  override func didBecomeActive() {
    super.didBecomeActive()

  }
  
  override func willResignActive() {
    super.willResignActive()
  }
}

// MARK: - Reactor

extension UserListInteractor {
  
  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return loadDataMutation()
      
    case .refresh:
     return refreshMutation()
            
    case .loadMore(let indexPath):
      return loadMoreMutation(by: indexPath)
      
    case .itemSelected(let indexPath):
      return itemSelectedMutation(by: indexPath)
    }
  }
  
  private func loadDataMutation() -> Observable<Mutation> {
    let startLoading = Observable.just(Mutation.setLoading(true))
    let stopLoading = Observable.just(Mutation.setLoading(false))
    
    let loadData = randomUserUseCase.loadData(isRefresh: true)
      .map { Mutation.loadData }
    
    return .concat([startLoading, loadData, stopLoading])
  }
  
  private func refreshMutation() -> Observable<Mutation> {
    let startRefresh = Observable.just(Mutation.setRefresh(true))
    let stopRefresh = Observable.just(Mutation.setRefresh(false))
    
    let loadData = randomUserUseCase.loadData(isRefresh: true)
      .map { Mutation.loadData }
      .catchErrorJustReturn(.setRefresh(false))
    
    return .concat([startRefresh, loadData, stopRefresh])
  }
  
  private func loadMoreMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let itemsCount = currentState.userListSections.first?.items.count ?? 0
    let lastItemIndexPathRow = itemsCount - 1
    guard indexPath.row == lastItemIndexPathRow else { return .empty() }
    
    return randomUserUseCase.loadData(isRefresh: false)
      .map { Mutation.loadData }
  }
  
  private func itemSelectedMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let sections = currentState.userListSections
    let section = sections[safe: indexPath.section]
    guard let item = section?.items[safe: indexPath.row] else { return .empty() }
    
    switch item {
    case .user(let viewModel):
      return .just(.selectedUser(viewModel.userModel))
      
    case .dummy:
      return .empty()
    }
  }
  
  // MARK: - transform
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .flatMap { [weak self] mutation -> Observable<Mutation> in
        guard let this = self else { return .empty() }
        switch mutation {
        case .loadData:
          return this.updateUserModelsMutation()
          
        case .selectedUser(let userModel):
          return this.transformSelectedUser(by: userModel)
          
        default:
          return .just(mutation)
        }
    }
  }

  /// mutableUserModelsStream is update userModels when trigger Action
  /// (.loadData, .refresh, .loadMore)
  private func updateUserModelsMutation() -> Observable<Mutation> {
    return randomUserUseCase
      .mutableUserModelsStream
      .userModels
      .map { $0.map { UserListViewModel(userModel: $0) } }
      .map { $0.map(UserListSectionItem.user) }
      .map { [UserListSectionModel.randomUser($0)] }
      .map(Mutation.userListSections)
  }
   
  /// Show selected user information
  private func transformSelectedUser(by userModel: UserModel) -> Observable<Mutation> {
    router?.attachUserInfomationRIB(with: userModel)
    return .empty()
  }
  
  // MARK: - reduce
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .loadData:
      // Do Nothing
      Log.debug("loadData")
      
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
      
    case .setRefresh(let isRefesh):
      newState.isRefresh = isRefesh
      
    case .userListSections(let sections):
      newState.userListSections = sections
      
    case .selectedUser(let userModel):
      // Do Nothing
      Log.debug("selectedUser: \(userModel)")
    }
    
    return newState
  }
}

// MARK: - UserInfomationAdapterListener
extension UserListInteractor {
  func detachUserInfomationRIB() {
    router?.detachUserInfomationRIB()
  }
}
