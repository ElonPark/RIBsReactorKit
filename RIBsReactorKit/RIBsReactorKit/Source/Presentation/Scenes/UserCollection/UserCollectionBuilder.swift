//
//  UserCollectionBuilder.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

// MARK: - UserCollectionDependency

protocol UserCollectionDependency: UserCollectionDependencyUserInformation {
  var randomUserUseCase: RandomUserUseCase { get }
  var userModelDataStream: UserModelDataStream { get }
  var userCollectionViewController: UserCollectionViewControllable { get }
}

// MARK: - UserCollectionComponent

final class UserCollectionComponent: Component<UserCollectionDependency> {

  var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  fileprivate var initialState: UserCollectionState {
    UserCollectionState()
  }

  fileprivate var randomUserUseCase: RandomUserUseCase {
    dependency.randomUserUseCase
  }

  fileprivate var userModelDataStream: UserModelDataStream {
    dependency.userModelDataStream
  }

  fileprivate var userCollectionViewController: UserCollectionViewControllable {
    dependency.userCollectionViewController
  }
}

// MARK: - UserCollectionBuildable

protocol UserCollectionBuildable: Buildable {
  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting
}

// MARK: - UserCollectionBuilder

final class UserCollectionBuilder: Builder<UserCollectionDependency>, UserCollectionBuildable {

  override init(dependency: UserCollectionDependency) {
    super.init(dependency: dependency)
  }

  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting {
    let component = UserCollectionComponent(dependency: dependency)
    let presenter = UserCollectionPresenter(viewController: component.userCollectionViewController)
    let interactor = UserCollectionInteractor(
      initialState: component.initialState,
      randomUserUseCase: component.randomUserUseCase,
      userModelDataStream: component.userModelDataStream,
      mutableSelectedUserModelStream: component.mutableSelectedUserModelStream,
      presenter: presenter
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder(dependency: component)

    return UserCollectionRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: component.userCollectionViewController
    )
  }
}
