//
//  UserInformationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - UserInformationDependency

protocol UserInformationDependency: UserInformationDependencyUserLocation {
  var selectedUserModelStream: SelectedUserModelStream { get }
}

// MARK: - UserInformationComponent

final class UserInformationComponent: Component<UserInformationDependency> {

  fileprivate var selectedUserModelStream: SelectedUserModelStream {
    dependency.selectedUserModelStream
  }

  fileprivate var initialState: UserInformationPresentableState {
    UserInformationPresentableState()
  }

  private var userInformationSectionFactories: [UserInfoSectionFactory] {
    [ProfileSectionFactory(), BasicInfoSectionFactory(), LocationSectionFactory()]
  }

  fileprivate var userInformationSectionListFactory: UserInfoSectionListFactory {
    UserInfoSectionListFactoryImpl(factories: userInformationSectionFactories)
  }
}

// MARK: - UserInformationBuildable

protocol UserInformationBuildable: Buildable {
  func build(withListener listener: UserInformationListener) -> UserInformationRouting
}

// MARK: - UserInformationBuilder

final class UserInformationBuilder:
  Builder<UserInformationDependency>,
  UserInformationBuildable
{

  func build(withListener listener: UserInformationListener) -> UserInformationRouting {
    let component = UserInformationComponent(dependency: dependency)
    let viewController = UserInformationViewController()
    let interactor = UserInformationInteractor(
      initialState: component.initialState,
      selectedUserModelStream: component.selectedUserModelStream,
      userInformationSectionListFactory: component.userInformationSectionListFactory,
      presenter: viewController
    )
    interactor.listener = listener

    let userLocationBuilder = UserLocationBuilder(dependency: component)

    return UserInformationRouter(
      userLocationBuilder: userLocationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}
