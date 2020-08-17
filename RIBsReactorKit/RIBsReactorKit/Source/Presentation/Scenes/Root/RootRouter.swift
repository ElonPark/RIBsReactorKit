//
//  RootRouter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol RootInteractable:
  Interactable,
  MainTabBarListener
{
  var router: RootRouting? { get set }
  var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {}

final class RootRouter:
  LaunchRouter<RootInteractable, RootViewControllable>,
  RootRouting
{
  
  // MARK: - Properties
  
  private var currentChild: ViewableRouting?
  private var mainTabBarBuilder: MainTabBarBuildable
  
  // MARK: - Initialization & Deinitialization

  init(
    mainTabBarBuilder: MainTabBarBuildable,
    interactor: RootInteractable,
    viewController: RootViewControllable
  ) {
    self.mainTabBarBuilder = mainTabBarBuilder

    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
}

// MARK: - RootRouting
extension RootRouter {
  func attachMainTapBarRIB() {
    let router = mainTabBarBuilder.build(withListener: interactor)
    currentChild = router
    attachChild(router)
    viewController.present(router.viewControllable, animated: false)
  }
}
