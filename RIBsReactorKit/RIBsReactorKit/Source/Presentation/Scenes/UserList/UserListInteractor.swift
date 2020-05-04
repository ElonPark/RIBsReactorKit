//
//  UserListInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift
import ReactorKit

protocol UserListRouting: ViewableRouting {

}

protocol UserListPresentable: Presentable {
  var listener: UserListPresentableListener? { get set }
  
}

protocol UserListListener: class {
 
}

final class UserListInteractor:
  PresentableInteractor<UserListPresentable>,
  UserListInteractable,
  UserListPresentableListener,
  Reactor
{
  
  typealias Action = UserListViewController.Action
  
  enum Mutation {
    case none
    case setLoadMore
  }
  
  typealias State = UserListState
  
  // MARK: - Properties

  weak var router: UserListRouting?
  weak var listener: UserListListener?
  
  var initialState: UserListState = .init()
  
  private let randomUserUseCase: RandomUserUseCase
  
  // MARK: - Initialization & Deinitialization

  init(randomUserUseCase: RandomUserUseCase, presenter: UserListPresentable) {
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
  func mutate(action: Action) -> Observable<Mutation> {
    //// TODO: - 구현 2020-05-05 01:08:52
    return .just(.none)
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let updateUserModel = randomUserUseCase.mutableUserModelsStream.userModels
      .
    return Observable.of(mutation, updateUserModel).merge()
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    //// TODO: - 구현 2020-05-05 01:08:52
    var newState = state
    return newState
  }
}
