//
//  UserCollectionInteractor.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs
import RxSwift

protocol UserCollectionRouting: ViewableRouting {}

// MARK: - UserCollectionPresentable

protocol UserCollectionPresentable: Presentable {
  var listener: UserCollectionPresentableListener? { get set }
}

protocol UserCollectionListener: AnyObject {}

// MARK: - UserCollectionInteractor

final class UserCollectionInteractor:
  PresentableInteractor<UserCollectionPresentable>,
  UserCollectionInteractable,
  UserCollectionPresentableListener
{

  // MARK: - Properties

  weak var router: UserCollectionRouting?
  weak var listener: UserCollectionListener?

  private let randomUserUseCase: RandomUserUseCase
  private let userModelDataStream: UserModelDataStream
  private let mutableUserModelStream: MutableSelectedUserModelStream

  init(
    randomUserUseCase: RandomUserUseCase,
    userModelDataStream: UserModelDataStream,
    mutableUserModelStream: MutableSelectedUserModelStream,
    presenter: UserCollectionPresentable
  ) {
    self.randomUserUseCase = randomUserUseCase
    self.userModelDataStream = userModelDataStream
    self.mutableUserModelStream = mutableUserModelStream
    super.init(presenter: presenter)
    presenter.listener = self
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }

  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
}
