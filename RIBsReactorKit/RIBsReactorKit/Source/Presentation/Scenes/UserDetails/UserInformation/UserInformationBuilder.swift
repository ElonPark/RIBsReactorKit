//
//  UserInformationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import NeedleFoundation
import RIBs

// MARK: - UserInformationDependency

protocol UserInformationDependency: NeedleFoundation.Dependency {
  var selectedUserModelStream: SelectedUserModelStream { get }
}

// MARK: - UserInformationComponent

final class UserInformationComponent:
  NeedleFoundation.Component<UserInformationDependency>,
  UserInformationInteractorDependency
{

  var initialState: UserInformationPresentableState {
    UserInformationPresentableState()
  }

  var selectedUserModelStream: SelectedUserModelStream {
    dependency.selectedUserModelStream
  }

  var userInformationSectionListFactory: UserInfoSectionListFactory {
    UserInfoSectionListFactoryImpl(factories: userInformationSectionFactories)
  }

  private var userInformationSectionFactories: [UserInfoSectionFactory] {
    [ProfileSectionFactory(), BasicInfoSectionFactory(), LocationSectionFactory()]
  }

  fileprivate func userLocationComponent(
    wit annotationMetadata: MapPointAnnotationMetadata
  ) -> UserLocationComponent {
    return UserLocationComponent(parent: self, annotationMetadata: annotationMetadata)
  }
}

// MARK: - UserInformationBuildable

protocol UserInformationBuildable: Buildable {
  func build(withListener listener: UserInformationListener) -> UserInformationRouting
}

// MARK: - UserInformationBuilder

final class UserInformationBuilder:
  ComponentizedBuilder<UserInformationComponent, UserInformationRouting, UserInformationListener, Void>,
  UserInformationBuildable
{

  override func build(
    with component: UserInformationComponent,
    _ listener: UserInformationListener
  ) -> UserInformationRouting {
    let viewController = UserInformationViewController()
    let interactor = UserInformationInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener

    let userLocationBuilder = UserLocationBuilder(componentBuilder: component.userLocationComponent)

    return UserInformationRouter(
      userLocationBuilder: userLocationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }

  func build(withListener listener: UserInformationListener) -> UserInformationRouting {
    return build(withDynamicBuildDependency: listener, dynamicComponentDependency: Void())
  }
}
