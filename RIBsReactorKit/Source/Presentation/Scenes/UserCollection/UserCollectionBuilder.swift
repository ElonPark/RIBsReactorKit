//
//  UserCollectionBuilder.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/10.
//  Copyright © 2021 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - UserCollectionDependency

protocol UserCollectionDependency: NeedleFoundation.Dependency {
  var randomUserRepositoryService: RandomUserRepositoryService { get }
  var userModelDataStream: UserModelDataStream { get }
  var imagePrefetchWorker: ImagePrefetchWorking { get }
}

// MARK: - UserCollectionBuildDependency

struct UserCollectionBuildDependency {
  let listener: UserCollectionListener
}

// MARK: - UserCollectionComponent

final class UserCollectionComponent: NeedleFoundation.Component<UserCollectionDependency> {
  var initialState: UserCollectionState {
    UserCollectionState()
  }

  var mutableSelectedUserModelStream: MutableSelectedUserModelStream {
    shared { SelectedUserModelStreamImpl() }
  }

  var selectedUserModelStream: SelectedUserModelStream {
    self.mutableSelectedUserModelStream
  }

  fileprivate var userInformationBuilder: UserInformationBuildable {
    UserInformationBuilder {
      UserInformationComponent(parent: self)
    }
  }
}

// MARK: - UserCollectionBuildable

/// @mockable
protocol UserCollectionBuildable: Buildable {
  func build(with dynamicBuildDependency: UserCollectionBuildDependency) -> UserCollectionRouting
}

// MARK: - UserCollectionBuilder

final class UserCollectionBuilder:
  ComponentizedBuilder<UserCollectionComponent, UserCollectionRouting, UserCollectionBuildDependency, Void>,
  UserCollectionBuildable
{

  override func build(
    with component: UserCollectionComponent,
    _ payload: UserCollectionBuildDependency
  ) -> UserCollectionRouting {
    let viewController = UserCollectionViewController()
    let presenter = UserCollectionPresenter(viewController: viewController)
    let interactor = UserCollectionInteractor(
      presenter: presenter,
      initialState: component.initialState,
      randomUserRepositoryService: component.randomUserRepositoryService,
      userModelDataStream: component.userModelDataStream,
      mutableSelectedUserModelStream: component.mutableSelectedUserModelStream,
      imagePrefetchWorker: component.imagePrefetchWorker
    )
    interactor.listener = payload.listener

    return UserCollectionRouter(
      userInformationBuilder: component.userInformationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}
