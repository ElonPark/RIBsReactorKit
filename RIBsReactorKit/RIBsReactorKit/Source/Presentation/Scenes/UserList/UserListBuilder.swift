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
  var userListViewController: UserListPresentable & UserListViewControllable { get }
}

// MARK: - UserListComponent

final class UserListComponent: NeedleFoundation.Component<UserListDependency> {

  fileprivate var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  fileprivate var initialState: UserListPresentableState {
    // for skeleton view animation
    let dummySectionItems: [UserListSectionItem] = (1...20).map { _ in .dummy }
    return UserListPresentableState(isLoading: true, userListSections: [.randomUser(dummySectionItems)])
  }

  fileprivate var randomUserRepositoryService: RandomUserRepositoryService {
    dependency.randomUserRepositoryService
  }

  fileprivate var userModelDataStream: UserModelDataStream {
    dependency.userModelDataStream
  }

  fileprivate var imagePrefetchWorker: ImagePrefetchWorking {
    ImagePrefetchWorker()
  }

  fileprivate var userListViewController: UserListPresentable & UserListViewControllable {
    dependency.userListViewController
  }

  fileprivate var userInformationComponent: UserInformationComponent {
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
    let interactor = UserListInteractor(
      initialState: component.initialState,
      randomUserRepositoryService: component.randomUserRepositoryService,
      userModelDataStream: component.userModelDataStream,
      mutableSelectedUserModelStream: component.mutableSelectedUserModelStream,
      imagePrefetchWorker: component.imagePrefetchWorker,
      presenter: component.userListViewController
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder {
      component.userInformationComponent
    }

    return UserListRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: component.userListViewController
    )
  }

  // MARK: - UserListBuildable

  func build(withListener listener: UserListListener) -> UserListRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
