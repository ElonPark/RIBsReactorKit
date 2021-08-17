//
//  RootBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {}

// MARK: - RootComponent

final class RootComponent: Component<RootDependency> {

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
}

// MARK: - RootBuildable

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

// MARK: - RootBuilder

final class RootBuilder: Builder<RootDependency>, RootBuildable {

  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }

  func build() -> LaunchRouting {
    let component = RootComponent(dependency: dependency)
    let interactor = RootInteractor()

    let mainTabBarBuilder = MainTabBarBuilder(dependency: component)

    return RootRouter(
      mainTabBarBuilder: mainTabBarBuilder,
      interactor: interactor,
      viewController: component.mainTabBarViewController
    )
  }
}
