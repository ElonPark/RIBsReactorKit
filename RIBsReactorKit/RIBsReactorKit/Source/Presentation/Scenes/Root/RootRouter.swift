//
//  RootRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - RootInteractable

protocol RootInteractable: Interactable, MainTabBarListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

// MARK: - RootRouter

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

  private var mainTabBarBuilder: MainTabBarBuildable
  private var mainTabBarRouter: MainTabBarRouting?

  init(
    mainTabBarBuilder: MainTabBarBuildable,
    interactor: RootInteractable,
    viewController: RootViewControllable
  ) {
    self.mainTabBarBuilder = mainTabBarBuilder
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }

  func cleanupViews() {
    detachMainTapBarRIB()
  }
}

extension RootRouter {
  func attachMainTapBarRIB() {
    guard mainTabBarRouter == nil else { return }

    let router = mainTabBarBuilder.build(withListener: interactor)
    mainTabBarRouter = router
    attachChild(router)
  }

  private func detachMainTapBarRIB() {
    guard let router = mainTabBarRouter else { return }
    detachChild(router)
    mainTabBarRouter = nil
  }
}
