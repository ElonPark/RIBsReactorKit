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
}

// MARK: - UserCollectionComponent

final class UserCollectionComponent:
  NeedleFoundation.Component<UserCollectionDependency>,
  UserCollectionInteractorDependency
{

  var initialState: UserCollectionState {
    UserCollectionState()
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

  fileprivate var userInformationComponent: UserInformationComponent {
    UserInformationComponent(parent: self)
  }
}

extension UserCollectionComponent {
  var selectedUserModelStream: SelectedUserModelStream {
    mutableSelectedUserModelStream
  }
}

// MARK: - UserCollectionBuildable

protocol UserCollectionBuildable: Buildable {
  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting
}

// MARK: - UserCollectionBuilder

final class UserCollectionBuilder:
  ComponentizedBuilder<UserCollectionComponent, UserCollectionRouting, UserCollectionListener, Void>,
  UserCollectionBuildable
{

  override func build(
    with component: UserCollectionComponent,
    _ listener: UserCollectionListener
  ) -> UserCollectionRouting {
    let viewController = UserCollectionViewController()
    let presenter = UserCollectionPresenter(viewController: viewController)
    let interactor = UserCollectionInteractor(
      presenter: presenter,
      dependency: component
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder {
      component.userInformationComponent
    }

    return UserCollectionRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }

  // MARK: - UserCollectionBuildable

  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
