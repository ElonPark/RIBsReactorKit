//
//  UserCollectionInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
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

  // MARK: - Initialization & Deinitialization

  init(randomUserUseCase: RandomUserUseCase, presenter: UserCollectionPresentable) {
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
