//
//  RootRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - RootInteractable

/// @mockable
protocol RootInteractable: Interactable, MainTabBarListener {
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

/// @mockable
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
    detachMainTabBarRIB()
  }
}

extension RootRouter {
  func attachMainTabBarRIB() {
    guard self.mainTabBarRouter == nil else { return }
    let router = self.mainTabBarBuilder.build(
      with: MainTabBarBuildDependency(
        listener: interactor
      )
    )
    self.mainTabBarRouter = router
    attachChild(router)
  }

  private func detachMainTabBarRIB() {
    guard let router = mainTabBarRouter else { return }
    self.mainTabBarRouter = nil
    detachChild(router)
  }
}
