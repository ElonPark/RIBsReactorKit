//
//  RootBuilder.swift
//  Smithsonian
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol RootDependency: Dependency {
 
}

final class RootComponent: Component<RootDependency> {
  
  // MARK: - Constants

  let rootViewController: RootViewController
  
  // MARK: - Initialization & Deinitialization
  
  init(
    dependency: RootDependency,
    rootViewController: RootViewController
  ) {
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
  func build() -> LaunchRouting
}

final class RootBuilder:
  Builder<RootDependency>,
  RootBuildable
{
  
  // MARK: - Initialization & Deinitialization

  override init(dependency: RootDependency) {
    super.init(dependency: dependency)
  }
  
  // MARK: - Internal methods

  func build() -> LaunchRouting {
    let viewController = RootViewController()
    _ = RootComponent(dependency: dependency, rootViewController: viewController)
    let interactor = RootInteractor(presenter: viewController)
    return RootRouter(interactor: interactor, viewController: viewController)
  }
}
