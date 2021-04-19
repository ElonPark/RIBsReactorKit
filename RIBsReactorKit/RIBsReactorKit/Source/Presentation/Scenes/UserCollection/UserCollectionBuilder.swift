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
  var randomUserUseCase: RandomUserUseCase { get }
  var userModelDataStream: UserModelDataStream { get }
  var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable { get }
}

// MARK: - UserCollectionComponent

final class UserCollectionComponent: Component<UserCollectionDependency> {

  var userModelStream: UserModelStream {
    mutableUserModelStream
  }

  fileprivate var mutableUserModelStream: MutableUserModelStream {
    shared { UserModelStreamImpl() }
  }

  fileprivate var randomUserUseCase: RandomUserUseCase {
    dependency.randomUserUseCase
  }

  fileprivate var userModelDataStream: UserModelDataStream {
    dependency.userModelDataStream
  }

  fileprivate var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable {
    dependency.userCollectionViewController
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
      userModelDataStream: component.userModelDataStream,
      mutableUserModelStream: component.mutableUserModelStream,
      presenter: component.userCollectionViewController
    )
    interactor.listener = listener

    return UserCollectionRouter(
      interactor: interactor,
      viewController: component.userCollectionViewController
    )
  }
}
