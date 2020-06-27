//
//  UserInfomationInteractor.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift

protocol UserInfomationRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol UserInfomationPresentable: Presentable {
  var listener: UserInfomationPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol UserInfomationListener: class {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class UserInfomationInteractor: PresentableInteractor<UserInfomationPresentable>, UserInfomationInteractable, UserInfomationPresentableListener {
  
  weak var router: UserInfomationRouting?
  weak var listener: UserInfomationListener?
  
  private let userModel: UserModel
  
  init(userModel: UserModel, presenter: UserInfomationPresentable) {
    self.userModel = userModel
    
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
