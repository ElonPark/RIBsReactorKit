//
//  UserInformationInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import ReactorKit
import RIBs
import RxSwift

protocol UserInformationRouting: ViewableRouting {}

// MARK: - UserInformationPresentable

protocol UserInformationPresentable: Presentable {
  var listener: UserInformationPresentableListener? { get set }
}

// MARK: - UserInformationListener

protocol UserInformationListener: AnyObject {
  func detachUserInformationRIB()
}

// MARK: - UserInformationInteractor

final class UserInformationInteractor:
  PresentableInteractor<UserInformationPresentable>,
  UserInformationInteractable,
  UserInformationPresentableListener,
  Reactor
{

  // MARK: - Reactor

  typealias Action = UserInformationPresentableAction
  typealias State = UserInformationPresentableState

  enum Mutation: Equatable {
    case setUserInformationSections([UserInfoSectionModel])
    case detach
  }

  // MARK: - Properties

  weak var router: UserInformationRouting?
  weak var listener: UserInformationListener?

  let initialState: UserInformationPresentableState

  private let userModelStream: UserModelStream
  private let userInformationSectionListFactory: UserInfoSectionListFactory

  // MARK: - Initialization & Deinitialization

  init(
    initialState: UserInformationPresentableState,
    userModelStream: UserModelStream,
    userInformationSectionListFactory: UserInfoSectionListFactory,
    presenter: UserInformationPresentable
  ) {
    self.initialState = initialState
    self.userModelStream = userModelStream
    self.userInformationSectionListFactory = userInformationSectionListFactory
    super.init(presenter: presenter)
    presenter.listener = self
  }

  deinit {
    Log.verbose(type(of: self))
  }
}

// MARK: - Reactor

extension UserInformationInteractor {

  // MARK: - mutate

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return setUserInformationSectionsMutation()

    case .detach:
      return .just(.detach)
    }
  }

  private func setUserInformationSectionsMutation() -> Observable<Mutation> {
    userModelStream.userModel
      .flatMap { [weak self] userModel -> Observable<Mutation> in
        guard let this = self else { return .empty() }
        let sections = this.userInformationSectionListFactory.makeSections(by: userModel)
        return .just(.setUserInformationSections(sections))
      }
  }

  // MARK: - transform mutation

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    mutation
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
    listener?.detachUserInformationRIB()
    return .empty()
  }

  // MARK: - reduce

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setUserInformationSections(sections):
      newState.userInformationSections = sections

    case .detach:
      // Do Nothing
      Log.debug("detach")
    }

    return newState
  }
}
