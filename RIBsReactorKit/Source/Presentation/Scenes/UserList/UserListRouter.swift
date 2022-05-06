//
//  UserListRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserListInteractable

protocol UserListInteractable: Interactable, UserInformationListener {
  var router: UserListRouting? { get set }
  var listener: UserListListener? { get set }
}

protocol UserListViewControllable: ViewControllable {}

// MARK: - UserListRouter

final class UserListRouter:
  ViewableRouter<UserListInteractable, UserListViewControllable>,
  UserListRouting
{

  private let userInformationBuilder: UserInformationBuildable
  private var userInformationRouter: UserInformationRouting?

  // MARK: - Initialization & Deinitialization

  init(
    userInformationBuilder: UserInformationBuildable,
    interactor: UserListInteractable,
    viewController: UserListViewControllable
  ) {
    self.userInformationBuilder = userInformationBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  func attachUserInformationRIB() {
    guard self.userInformationRouter == nil else { return }
    let router = self.userInformationBuilder.build(
      with: UserInformationBuildDependency(
        listener: interactor
      )
    )
    self.userInformationRouter = router
    attachChild(router)
    viewController.present(router.viewControllable)
  }

  func detachUserInformationRIB() {
    guard let router = userInformationRouter else { return }
    self.userInformationRouter = nil
    detachChild(router)
    viewController.dismiss(router.viewControllable)
  }
}
