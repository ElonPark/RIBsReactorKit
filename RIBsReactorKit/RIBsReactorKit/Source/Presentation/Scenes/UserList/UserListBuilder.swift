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
  var imagePrefetchWorker: ImagePrefetchWorking { get }
}

// MARK: - UserListBuildDependency

struct UserListBuildDependency {
  let listener: UserListListener
}

// MARK: - UserListComponent

final class UserListComponent: NeedleFoundation.Component<UserListDependency> {

  var initialState: UserListPresentableState {
    UserListPresentableState(
      isLoading: true,
      userListSections: [
        // for skeleton view animation
        .randomUser(Array(repeating: UserListSectionItem.dummy, count: 20))
      ]
    )
  }

  var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  var selectedUserModelStream: SelectedUserModelStream {
    mutableSelectedUserModelStream
  }

  fileprivate var userInformationBuilder: UserInformationBuildable{
    UserInformationBuilder {
      UserInformationComponent(parent: self)
    }
  }
}

// MARK: - UserListBuildable

protocol UserListBuildable: Buildable {
  func build(with dynamicBuildDependency: UserListBuildDependency) -> UserListRouting
}

// MARK: - UserListBuilder

final class UserListBuilder:
  ComponentizedBuilder<UserListComponent, UserListRouting, UserListBuildDependency, Void>,
  UserListBuildable
{

  override func build(
    with component: UserListComponent,
    _ payload: UserListBuildDependency
  ) -> UserListRouting {
    let viewController = UserListViewController()
    let interactor = UserListInteractor(
      presenter: viewController,
      initialState: component.initialState,
      randomUserRepositoryService: component.randomUserRepositoryService,
      userModelDataStream: component.userModelDataStream,
      mutableSelectedUserModelStream: component.mutableSelectedUserModelStream,
      imagePrefetchWorker: component.imagePrefetchWorker
    )
    interactor.listener = payload.listener

    return UserListRouter(
      userInformationBuilder: component.userInformationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}
