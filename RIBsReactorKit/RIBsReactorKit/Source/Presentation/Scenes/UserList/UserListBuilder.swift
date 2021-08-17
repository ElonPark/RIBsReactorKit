//
//  UserListBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserListDependency

protocol UserListDependency: UserListDependencyUserInformation {
  var randomUserUseCase: RandomUserUseCase { get }
  var userModelDataStream: UserModelDataStream { get }
  var userListViewController: UserListPresentable & UserListViewControllable { get }
}

// MARK: - UserListComponent

final class UserListComponent: Component<UserListDependency> {

  var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  fileprivate var initialState: UserListPresentableState {
    // for skeleton view animation
    let dummySectionItems: [UserListSectionItem] = (1...20).map { _ in .dummy }
    return UserListPresentableState(isLoading: true, userListSections: [.randomUser(dummySectionItems)])
  }

  fileprivate var randomUserUseCase: RandomUserUseCase {
    dependency.randomUserUseCase
  }

  fileprivate var userModelDataStream: UserModelDataStream {
    dependency.userModelDataStream
  }

  fileprivate var userListViewController: UserListPresentable & UserListViewControllable {
    dependency.userListViewController
  }
}

// MARK: - UserListBuildable

protocol UserListBuildable: Buildable {
  func build(withListener listener: UserListListener) -> UserListRouting
}

// MARK: - UserListBuilder

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
      userModelDataStream: component.userModelDataStream,
      mutableSelectedUserModelStream: component.mutableSelectedUserModelStream,
      presenter: component.userListViewController
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder(dependency: component)

    return UserListRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: component.userListViewController
    )
  }
}
