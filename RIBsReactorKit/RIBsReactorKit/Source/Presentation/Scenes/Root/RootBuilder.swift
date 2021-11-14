//
//  RootBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - RootComponent

protocol RootDependency: NeedleFoundation.Dependency {}

// MARK: - RootComponent

final class RootComponent: NeedleFoundation.Component<RootDependency> {

  var userListViewController: UserListPresentable & UserListViewControllable {
    shared { UserListViewController() }
  }

  var userCollectionViewController: UserCollectionViewControllable {
    shared { UserCollectionViewController() }
  }

  var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable {
    shared {
      MainTabBarViewController(viewControllers: [
        UINavigationController(root: userListViewController),
        UINavigationController(root: userCollectionViewController)
      ])
    }
  }

  var mainTabBarComponent: MainTabBarComponent {
    MainTabBarComponent(parent: self)
  }
}

// MARK: - RootBuildable

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

// MARK: - RootBuilder

final class RootBuilder: SimpleComponentizedBuilder<RootComponent, LaunchRouting>, RootBuildable {

  override func build(with component: RootComponent) -> LaunchRouting {
    let interactor = RootInteractor()

    let mainTabBarBuilder = MainTabBarBuilder {
      component.mainTabBarComponent
    }

    return RootRouter(
      mainTabBarBuilder: mainTabBarBuilder,
      interactor: interactor,
      viewController: component.mainTabBarViewController
    )
  }
}
