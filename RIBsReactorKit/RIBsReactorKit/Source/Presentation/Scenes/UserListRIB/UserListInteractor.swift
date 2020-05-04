//
//  UserListInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift

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
  UserListPresentableListener
{
  
  // MARK: - Properties

  weak var router: UserListRouting?
  weak var listener: UserListListener?
  
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
