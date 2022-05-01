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

// MARK: - UserInformationBuildDependency

struct UserInformationBuildDependency {
  let listener: UserInformationListener
}

// MARK: - UserInformationComponent

final class UserInformationComponent: NeedleFoundation.Component<UserInformationDependency> {

  fileprivate var initialState: UserInformationPresentableState {
    UserInformationPresentableState()
  }

  fileprivate var userInformationSectionListFactory: UserInfoSectionListFactory {
    UserInfoSectionListFactoryImpl(factories: userInformationSectionFactories)
  }

  private var userInformationSectionFactories: [UserInfoSectionFactory] {
    [ProfileSectionFactory(), BasicInfoSectionFactory(), LocationSectionFactory()]
  }

  fileprivate var userLocationBuilder: UserLocationBuildable {
    UserLocationBuilder { payload in
      UserLocationComponent(
        parent: self,
        payload: payload
      )
    }
  }
}

// MARK: - UserInformationBuildable

protocol UserInformationBuildable: Buildable {
  func build(with dynamicBuildDependency: UserInformationBuildDependency) -> UserInformationRouting
}

// MARK: - UserInformationBuilder

final class UserInformationBuilder:
  ComponentizedBuilder<UserInformationComponent, UserInformationRouting, UserInformationBuildDependency, Void>,
  UserInformationBuildable
{

  override func build(
    with component: UserInformationComponent,
    _ payload: UserInformationBuildDependency
  ) -> UserInformationRouting {
    let viewController = UserInformationViewController()
    let interactor = UserInformationInteractor(
      presenter: viewController,
      initialState: component.initialState,
      selectedUserModelStream: component.selectedUserModelStream,
      userInformationSectionListFactory: component.userInformationSectionListFactory
    )
    interactor.listener = payload.listener

    return UserInformationRouter(
      userLocationBuilder: component.userLocationBuilder,
      interactor: interactor,
      viewController: viewController
    )
  }
}
