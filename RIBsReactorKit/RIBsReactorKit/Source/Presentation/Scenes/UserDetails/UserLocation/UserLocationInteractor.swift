//
//  UserLocationInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import ReactorKit
import RIBs

// MARK: - UserLocationRouting

protocol UserLocationRouting: ViewableRouting {}

// MARK: - UserLocationPresentable

protocol UserLocationPresentable: Presentable {
  var listener: UserLocationPresentableListener? { get set }
}

// MARK: - UserLocationListener

protocol UserLocationListener: AnyObject {
  func detachUserLocationRIB()
}

// MARK: - UserLocationInteractor

final class UserLocationInteractor:
  PresentableInteractor<UserLocationPresentable>,
  UserLocationInteractable,
  UserLocationPresentableListener,
  Reactor
{

  // MARK: - Types

  typealias Action = UserLocationPresentableAction
  typealias State = UserLocationPresentableState

  enum Mutation {
    case detach
  }

  // MARK: - Properties

  weak var router: UserLocationRouting?
  weak var listener: UserLocationListener?

  let initialState: UserLocationPresentableState

  // MARK: - Con(De)structor

  init(
    presenter: UserLocationPresentable,
    initialState: UserLocationPresentableState
  ) {
    self.initialState = initialState
    super.init(presenter: presenter)
    presenter.listener = self
  }

  deinit {
    Log.verbose(type(of: self))
  }
}

// MARK: - Reactor

extension UserLocationInteractor {

  func sendAction(_ action: Action) {
    self.action.on(.next(action))
  }

  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .detachAction:
      return .just(.detach)
    }
  }

  // MARK: - Transform mutation

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return mutation
      .withUnretained(self)
      .flatMap { this, mutation -> Observable<Mutation> in
        switch mutation {
        case .detach:
          return this.detachUserLocationRIBTransform()
        }
      }
  }

  private func detachUserLocationRIBTransform() -> Observable<Mutation> {
    listener?.detachUserLocationRIB()
    return .empty()
  }

  // MARK: - reduce

  func reduce(state: State, mutation: Mutation) -> State {
    let newState = state
    switch mutation {
    case .detach:
      Log.debug("Do Nothing when \(mutation)")
    }

    return newState
  }
}

// MARK: - UserLocationInteractable

extension UserLocationInteractor {}

// MARK: - UserLocationPresentableListener

extension UserLocationInteractor {}
