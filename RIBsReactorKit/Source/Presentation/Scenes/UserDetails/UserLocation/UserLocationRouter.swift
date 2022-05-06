//
//  UserLocationRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - UserLocationInteractable

protocol UserLocationInteractable: Interactable {
  var router: UserLocationRouting? { get set }
  var listener: UserLocationListener? { get set }
}

// MARK: - UserLocationViewControllable

protocol UserLocationViewControllable: ViewControllable {}

// MARK: - UserLocationRouter

final class UserLocationRouter:
  ViewableRouter<UserLocationInteractable, UserLocationViewControllable>,
  UserLocationRouting
{

  // MARK: - Initialization & Deinitialization

  override init(interactor: UserLocationInteractable, viewController: UserLocationViewControllable) {
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}
