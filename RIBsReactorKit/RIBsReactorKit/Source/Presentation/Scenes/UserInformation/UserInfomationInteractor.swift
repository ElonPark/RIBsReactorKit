//
//  UserInfomationInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import ReactorKit
import RxSwift

protocol UserInfomationRouting: ViewableRouting {}

protocol UserInfomationPresentable: Presentable {
  var listener: UserInfomationPresentableListener? { get set }
}

protocol UserInfomationListener: class {
  func detachUserInfomationRIB()
}

final class UserInfomationInteractor:
  PresentableInteractor<UserInfomationPresentable>,
  UserInfomationInteractable,
  UserInfomationPresentableListener,
  Reactor
{
  
  // MARK: - Reactor
  
  typealias Action = UserInfomationPresentableAction
  typealias State = UserInfomationPresentableState
  
  enum Mutation: Equatable {
    case setUserInfomationSections([UserInfoSectionModel])
    case detach
  }
  
  // MARK: - Properties
  
  weak var router: UserInfomationRouting?
  weak var listener: UserInfomationListener?
  
  let initialState: UserInfomationPresentableState
  
  private let userModelStream: UserModelStream
  private let userInfomationSectionListFactory: UserInfoSectionListFactory
  
  // MARK: - Initialization & Deinitialization
  
  init(
    initialState: UserInfomationPresentableState,
    userModelStream: UserModelStream,
    userInfomationSectionListFactory: UserInfoSectionListFactory,
    presenter: UserInfomationPresentable
  ) {
    self.initialState = initialState
    self.userModelStream = userModelStream
    self.userInfomationSectionListFactory = userInfomationSectionListFactory
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  deinit {
    Log.verbose(type(of: self))
  }
}

// MARK: - Reactor

extension UserInfomationInteractor {
  
  // MARK: - mutate
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return setUserInfomationSectionsMutation()
      
    case .detach:
      return .just(.detach)
    }
  }
  
  private func setUserInfomationSectionsMutation() -> Observable<Mutation> {
    return userModelStream.userModel
      .flatMap { [weak self] userModel -> Observable<Mutation> in
        guard let this = self else { return .empty() }
        let sections = this.userInfomationSectionListFactory.makeSections(by: userModel)
        return .just(.setUserInfomationSections(sections))
      }
  }

  // MARK: - transform mutation
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .flatMap { [weak self] mutation -> Observable<Mutation> in
      guard let this = self else { return .empty() }
      switch mutation {
      case .detach:
        return this.detachTransform()
        
      default:
        return .just(mutation)
      }
    }
  }
    
  private func detachTransform() -> Observable<Mutation> {
    listener?.detachUserInfomationRIB()
    return .empty()
  }
  
  // MARK: - reduce
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case .setUserInfomationSections(let sections):
      newState.userInfomationSections = sections
      
    case .detach:
      // Do Nothing
      Log.debug("detach")
    }
    
    return newState
  }
}
