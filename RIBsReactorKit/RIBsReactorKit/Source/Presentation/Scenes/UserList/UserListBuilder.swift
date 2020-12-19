//
//  UserListBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserListDependency: UserListDependencyUserInfomationAdapter {
  var userListViewController: UserListPresentable & UserListViewControllable { get }
  var randomUserUseCase: RandomUserUseCase { get }
}

final class UserListComponent: Component<UserListDependency> {
  
  fileprivate var initialState: UserListPresentableState {
    // for skeleton view animation
    let dummySectionItems: [UserListSectionItem] = (1...20).map { _ in .dummy }
    return UserListPresentableState(
      isLoading: true,
      userListSections: [.randomUser(dummySectionItems)]
    )
  }
  
  fileprivate var randomUserUseCase: RandomUserUseCase {
    dependency.randomUserUseCase
  }
  
  fileprivate var userListViewController: UserListPresentable & UserListViewControllable {
    dependency.userListViewController
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
      initialState: component.initialState,
      randomUserUseCase: component.randomUserUseCase,
      presenter: component.userListViewController
    )
    interactor.listener = listener
    
    let userInfomationAdapter = UserInfomationAdapter(dependency: component)
    
    return UserListRouter(
      userInfomationAdapter: userInfomationAdapter,
      interactor: interactor,
      viewController: component.userListViewController
    )
  }
}
