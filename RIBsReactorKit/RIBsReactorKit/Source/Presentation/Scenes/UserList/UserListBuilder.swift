//
//  UserListBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - UserListDependency

protocol UserListDependency: NeedleFoundation.Dependency {
  var randomUserRepositoryService: RandomUserRepositoryService { get }
  var userModelDataStream: UserModelDataStream { get }
}

// MARK: - UserListComponent

final class UserListComponent: NeedleFoundation.Component<UserListDependency>, UserListInteractorDependency {

  var initialState: UserListPresentableState {
    // for skeleton view animation
    let dummySectionItems: [UserListSectionItem] = (1...20).map { _ in .dummy }
    return UserListPresentableState(isLoading: true, userListSections: [.randomUser(dummySectionItems)])
  }

  var randomUserRepositoryService: RandomUserRepositoryService {
    dependency.randomUserRepositoryService
  }

  var userModelDataStream: UserModelDataStream {
    dependency.userModelDataStream
  }

  var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  var imagePrefetchWorker: ImagePrefetchWorking {
    ImagePrefetchWorker()
  }

  var userInformationComponent: UserInformationComponent {
    UserInformationComponent(parent: self)
  }
}

extension UserListComponent {
  var selectedUserModelStream: SelectedUserModelStream {
    mutableSelectedUserModelStream
  }
}

// MARK: - UserListBuildable

protocol UserListBuildable: Buildable {
  func build(withListener listener: UserListListener) -> UserListRouting
}

// MARK: - UserListBuilder

final class UserListBuilder:
  ComponentizedBuilder<UserListComponent, UserListRouting, UserListListener, Void>,
  UserListBuildable
{

  override func build(with component: UserListComponent, _ listener: UserListListener) -> UserListRouting {
    let viewController = UserListViewController()
    let interactor = UserListInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder {
      component.userInformationComponent
    }

    return UserListRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }

  // MARK: - UserListBuildable

  func build(withListener listener: UserListListener) -> UserListRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
