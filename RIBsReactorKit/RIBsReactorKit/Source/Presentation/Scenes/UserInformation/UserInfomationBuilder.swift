//
//  UserInfomationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserInfomationDependency: Dependency {
  var userModelStream: UserModelStream { get }
}

final class UserInfomationComponent: Component<UserInfomationDependency> {
  
  fileprivate var userModelStream: UserModelStream { dependency.userModelStream }
  
  fileprivate var initialState = UserInfomationPresentableState()
  
  private var userInfomationSectionFactories: [UserInfoSectionFactory] = [
    ProfileSectionFactory(),
    BasicInfoSectionFactory()
  ]
  
  fileprivate var userInfomationSectionListFactory: UserInfoSectionListFactory {
    UserInfoSectionListFactoryImpl(factories: userInfomationSectionFactories)
  }
}

// MARK: - Builder

protocol UserInfomationBuildable: Buildable {
  func build(withListener listener: UserInfomationListener) -> UserInfomationRouting
}

final class UserInfomationBuilder:
  Builder<UserInfomationDependency>,
  UserInfomationBuildable
{
  
  func build(withListener listener: UserInfomationListener) -> UserInfomationRouting {
    let component = UserInfomationComponent(dependency: dependency)
    let viewController = UserInfomationViewController()
    let interactor = UserInfomationInteractor(
      initialState: component.initialState,
      userModelStream: component.userModelStream,
      userInfomationSectionListFactory: component.userInfomationSectionListFactory,
      presenter: viewController
    )
    interactor.listener = listener
    return UserInfomationRouter(interactor: interactor, viewController: viewController)
  }
}
