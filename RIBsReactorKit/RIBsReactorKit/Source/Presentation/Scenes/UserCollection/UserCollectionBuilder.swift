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
  var userCollectionViewController: UserCollectionViewControllable { get }
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

  fileprivate var userCollectionViewController: UserCollectionViewControllable {
    dependency.userCollectionViewController
  }

  fileprivate var presenter: UserCollectionPresentable {
    UserCollectionPresenter(viewController: userCollectionViewController)
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
    let interactor = UserCollectionInteractor(
      presenter: component.presenter,
      dependency: component
    )
    interactor.listener = listener

    let userInformationBuilder = UserInformationBuilder {
      component.userInformationComponent
    }

    return UserCollectionRouter(
      userInformationBuilder: userInformationBuilder,
      interactor: interactor,
      viewController: component.userCollectionViewController
    )
  }

  // MARK: - UserCollectionBuildable

  func build(withListener listener: UserCollectionListener) -> UserCollectionRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
