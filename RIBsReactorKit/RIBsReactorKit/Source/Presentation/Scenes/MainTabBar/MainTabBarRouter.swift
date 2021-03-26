//
//  MainTabBarRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - MainTabBarInteractable

protocol MainTabBarInteractable:
  Interactable,
  UserListListener,
  UserCollectionListener
{
  var router: MainTabBarRouting? { get set }
  var listener: MainTabBarListener? { get set }
}

protocol MainTabBarViewControllable: ViewControllable {}

// MARK: - MainTabBarRouter

final class MainTabBarRouter:
  ViewableRouter<MainTabBarInteractable, MainTabBarViewControllable>,
  MainTabBarRouting
{

  // MARK: - Properties

  private let userListBuilder: UserListBuildable
  private let userCollectionBuilder: UserCollectionBuildable

  private var userListRouter: UserListRouting?
  private var userCollectionRouter: UserCollectionRouting?

  // MARK: - Initialization & Deinitialization

  init(
    userListBuilder: UserListBuildable,
    userCollectionBuilder: UserCollectionBuildable,
    interactor: MainTabBarInteractable,
    viewController: MainTabBarViewControllable
  ) {
    self.userListBuilder = userListBuilder
    self.userCollectionBuilder = userCollectionBuilder

    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  // MARK: - Inheritance

  override func didLoad() {
    super.didLoad()
    attachUserListRIB()
    attachUserCollectionRIB()
  }
}

// MARK: - MainTabBarRouting

extension MainTabBarRouter {
  func attachUserListRIB() {
    let router = userListBuilder.build(withListener: interactor)
    userListRouter = router
    attachChild(router)
  }

  func attachUserCollectionRIB() {
    let router = userCollectionBuilder.build(withListener: interactor)
    userCollectionRouter = router
    attachChild(router)
  }
}
