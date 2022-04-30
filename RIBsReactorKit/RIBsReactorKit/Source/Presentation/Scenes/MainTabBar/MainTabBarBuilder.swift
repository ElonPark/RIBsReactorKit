//
//  MainTabBarBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - MainTabBarDependency

protocol MainTabBarDependency: NeedleFoundation.Dependency {
  var mainTabBarViewController: RootViewControllable & MainTabBarPresentable & MainTabBarViewControllable { get }
}

// MARK: - MainTabBarBuildDependency

struct MainTabBarBuildDependency {
  let listener: MainTabBarListener
}

// MARK: - MainTabBarComponent

final class MainTabBarComponent: NeedleFoundation.Component<MainTabBarDependency> {

  fileprivate var userListBuilder: UserListBuildable {
    UserListBuilder {
      UserListComponent(parent: self)
    }
  }

  fileprivate var userCollectionBuilder: UserCollectionBuildable {
    UserCollectionBuilder {
      UserCollectionComponent(parent: self)
    }
  }
}

// MARK: - MainTabBarBuildable

protocol MainTabBarBuildable: Buildable {
  func build(with dynamicBuildDependency: MainTabBarBuildDependency) -> MainTabBarRouting
}

// MARK: - MainTabBarBuilder

final class MainTabBarBuilder:
  ComponentizedBuilder<MainTabBarComponent, MainTabBarRouting, MainTabBarBuildDependency, Void>,
  MainTabBarBuildable
{

  override func build(
    with component: MainTabBarComponent,
    _ payload: MainTabBarBuildDependency
  ) -> MainTabBarRouting {
    let interactor = MainTabBarInteractor(presenter: component.mainTabBarViewController)
    interactor.listener = payload.listener

    return MainTabBarRouter(
      userListBuilder: component.userListBuilder,
      userCollectionBuilder: component.userCollectionBuilder,
      interactor: interactor,
      viewController: component.mainTabBarViewController
    )
  }
}
