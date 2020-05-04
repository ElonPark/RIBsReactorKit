//
//  UserListBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserListDependency: Dependency {
  var userListViewController: UserListPresentable & UserListViewControllable { get }
  var randomUserUseCase: RandomUserUseCase { get }
}

final class UserListComponent: Component<UserListDependency> {
  fileprivate var userListViewController: UserListPresentable & UserListViewControllable {
    return dependency.userListViewController
  }
  
  fileprivate var randomUserUseCase: RandomUserUseCase {
    return dependency.randomUserUseCase
  }
}

// MARK: - Builder

protocol UserListBuildable: Buildable {
  func build(withListener listener: UserListListener) -> UserListRouting
}

final class UserListBuilder:
  Builder<UserListDependency>,
  UserListBuildable
{
  
  // MARK: - Initialization & Deinitialization
  
  override init(dependency: UserListDependency) {
    super.init(dependency: dependency)
  }
  
  // MARK: - Internal methods
  
  func build(withListener listener: UserListListener) -> UserListRouting {
    let component = UserListComponent(dependency: dependency)
    let interactor = UserListInteractor(
      randomUserUseCase: component.randomUserUseCase,
      presenter: component.userListViewController
    )
    interactor.listener = listener
    return UserListRouter(
      interactor: interactor,
      viewController: component.userListViewController
    )
  }
}
