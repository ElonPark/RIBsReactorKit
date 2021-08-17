//
//  UserCollectionRouter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - UserCollectionInteractable

protocol UserCollectionInteractable: Interactable, UserInformationListener {
  var router: UserCollectionRouting? { get set }
  var listener: UserCollectionListener? { get set }
}

// MARK: - UserCollectionViewControllable

protocol UserCollectionViewControllable: ViewControllable {
  var listener: UserCollectionViewControllableListener? { get set }
}

// MARK: - UserCollectionRouter

final class UserCollectionRouter:
  ViewableRouter<UserCollectionInteractable, UserCollectionViewControllable>,
  UserCollectionRouting
{

  private let userInformationBuilder: UserInformationBuildable
  private var userInformationRouter: UserInformationRouting?

  // MARK: - Initialization & Deinitialization

  init(
    userInformationBuilder: UserInformationBuilder,
    interactor: UserCollectionInteractable,
    viewController: UserCollectionViewControllable
  ) {
    self.userInformationBuilder = userInformationBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  func attachUserInformationRIB() {
    guard userInformationRouter == nil else { return }
    let router = userInformationBuilder.build(withListener: interactor)
    userInformationRouter = router
    attachChild(router)
    viewController.push(viewController: router.viewControllable)
  }

  func detachUserInformationRIB() {
    guard let router = userInformationRouter else { return }
    userInformationRouter = nil
    detachChild(router)
    viewController.pop(router.viewControllable)
  }
}
