//
//  UserInfomationRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserInfomationInteractable: Interactable {
  var router: UserInfomationRouting? { get set }
  var listener: UserInfomationListener? { get set }
}

protocol UserInfomationViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class UserInfomationRouter:
  ViewableRouter<UserInfomationInteractable, UserInfomationViewControllable>,
  UserInfomationRouting
{
  
  // TODO: Constructor inject child builder protocols to allow building children.
  override init(interactor: UserInfomationInteractable, viewController: UserInfomationViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
