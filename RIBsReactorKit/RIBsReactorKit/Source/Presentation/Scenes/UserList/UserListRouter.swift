//
//  UserListRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserListInteractable:
  Interactable,
  UserInfomationAdapterListener
{
  var router: UserListRouting? { get set }
  var listener: UserListListener? { get set }
}

protocol UserListViewControllable: ViewControllable {}

final class UserListRouter:
  ViewableRouter<UserListInteractable, UserListViewControllable>,
  UserListRouting
{
  
  private let userInfomationAdapter: UserInfomationAdapterBuildable
  
  private var userInfomationRouter: UserInfomationRouting?
  
  // MARK: - Initialization & Deinitialization

  init(
    userInfomationAdapter: UserInfomationAdapterBuildable,
    interactor: UserListInteractable,
    viewController: UserListViewControllable
  ) {
    self.userInfomationAdapter = userInfomationAdapter
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  //// FIXME: - fix after implementation UserInfomationRIB  2020-06-23 23:57:29
  func attachUserInfomationRIB(with userModel: UserModel) {
    let router = userInfomationAdapter.build(
      userModel: userModel,
      withListener: interactor
    )
    userInfomationRouter = router
    attachChild(router)
    viewController.present(router.viewControllable)
  }
  
  //// FIXME: - fix after implementation UserInfomationRIB  2020-06-23 23:57:29
  func dettachUserInfomationRIB() {
    guard let router = userInfomationRouter else { return }
    detachChild(router)
    viewController.dismiss(router.viewControllable)
    userInfomationRouter = nil
  }
}
