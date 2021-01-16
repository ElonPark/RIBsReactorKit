//
//  RootBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {}

final class RootComponent: Component<RootDependency> {

  let userListViewController: UserListPresentable & UserListViewControllable
  let userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable
  let mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable

  init(
    dependency: RootDependency,
    userListViewController: UserListPresentable & UserListViewControllable,
    userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable,
    mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable
  ) {
    self.userListViewController = userListViewController
    self.userCollectionViewController = userCollectionViewController
    self.mainTabBarViewController = mainTabBarViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }

  func build() -> LaunchRouting {
    let userListViewController = UserListViewController()
    let userCollectionViewController = UserCollectionViewController()
    let mainTabBarViewController = MainTabBarViewController(viewControllers: [
      UINavigationController(root: userListViewController),
      UINavigationController(root: userCollectionViewController)
    ])

    let component = RootComponent(
      dependency: dependency,
      userListViewController: userListViewController,
      userCollectionViewController: userCollectionViewController,
      mainTabBarViewController: mainTabBarViewController
    )
    let interactor = RootInteractor()

    let mainTabBarBuilder = MainTabBarBuilder(dependency: component)

    return RootRouter(
      mainTabBarBuilder: mainTabBarBuilder,
      interactor: interactor,
      viewController: component.mainTabBarViewController
    )
  }
}
