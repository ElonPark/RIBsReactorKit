//
//  UserCollectionBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserCollectionDependency

protocol UserCollectionDependency: Dependency {
  var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable { get }
  var randomUserUseCase: RandomUserUseCase { get }
}

// MARK: - UserCollectionComponent

final class UserCollectionComponent: Component<UserCollectionDependency> {

  fileprivate var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable {
    dependency.userCollectionViewController
  }

  fileprivate var randomUserUseCase: RandomUserUseCase {
    dependency.randomUserUseCase
  }
}

// MARK: - UserCollectionBuildable

protocol UserCollectionBuildable: Buildable {
  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting
}

// MARK: - UserCollectionBuilder

final class UserCollectionBuilder:
  Builder<UserCollectionDependency>,
  UserCollectionBuildable
{

  // MARK: - Initialization & Deinitialization

  override init(dependency: UserCollectionDependency) {
    super.init(dependency: dependency)
  }

  // MARK: - Internal methods

  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting {
    let component = UserCollectionComponent(dependency: dependency)
    let interactor = UserCollectionInteractor(
      randomUserUseCase: component.randomUserUseCase,
      presenter: component.userCollectionViewController
    )
    interactor.listener = listener
    return UserCollectionRouter(
      interactor: interactor,
      viewController: component.userCollectionViewController
    )
  }
}
