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
  func dettachUserInfomationRIB()
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
  
  // MARK: - Reactor
  
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
  
  var initialState: UserListPresentableState
  
  private let randomUserUseCase: RandomUserUseCase
  private let requestItemCount: Int = 50
  
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
}

// MARK: - Reactor
extension UserListInteractor {
  
  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return refreshMutation()
      
    case .refresh:
     return refreshMutation()
            
    case .loadMore(let indexPath):
      return loadMoreMutation(by: indexPath)
      
    case .itemSelected(let indexPath):
      return itemSelectedMutation(by: indexPath)
    }
  }
  
  private func refreshMutation() -> Observable<Mutation> {
    let startRefresh = Observable.just(Mutation.setRefresh(true))
    let stopRefresh = Observable.just(Mutation.setRefresh(false))
    
    let loadData = randomUserUseCase.loadData(isRefresh: true, itemCount: requestItemCount)
      .map { Mutation.loadData }
    
    return .concat([startRefresh, loadData, stopRefresh])
  }
  
  private func loadMoreMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let itemsCount = currentState.userListSections.first?.items.count ?? 0
    let lastItemIndexPathRow = itemsCount - 1
    guard indexPath.row == lastItemIndexPathRow else { return .empty() }
    
    return randomUserUseCase.loadData(isRefresh: false, itemCount: requestItemCount)
      .map { Mutation.loadData }
  }
  
  private func itemSelectedMutation(by indexPath: IndexPath) -> Observable<Mutation> {
    let sections = currentState.userListSections
    let section = sections[safe: indexPath.section]
    guard let item = section?.items[safe: indexPath.row] else { return .empty() }
    
    switch item {
    case .user(let userModel):
      guard let userModel = userModel else { return .empty() }
      return .just(.selectedUser(userModel))
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
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
      
    case .setRefresh(let isRefesh):
      newState.isRefresh = isRefesh
      
    case .userListSections(let sections):
      newState.userListSections = sections
      
    case .loadData, .selectedUser:
      Log.debug("Do Nothing when \(mutation)")
    }
    
    return newState
  }
}

// MARK: - UserInfomationAdapterListener
extension UserListInteractor {
  func dettachUserInfomationRIB() {
    router?.dettachUserInfomationRIB()
  }
}
