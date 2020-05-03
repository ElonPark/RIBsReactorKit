//
//  UserListRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserListInteractable: Interactable {
  var router: UserListRouting? { get set }
  var listener: UserListListener? { get set }
}

protocol UserListViewControllable: ViewControllable {
  
}

final class UserListRouter:
  ViewableRouter<UserListInteractable, UserListViewControllable>,
  UserListRouting
{
    
  // MARK: - Initialization & Deinitialization

  override init(interactor: UserListInteractable, viewController: UserListViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
