//
//  UserInfomationBuilder.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserInfomationDependency: Dependency {
  var userModel: UserModel { get }
}

final class UserInfomationComponent: Component<UserInfomationDependency> {
  fileprivate var userModel: UserModel { dependency.userModel }
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
      userModel: component.userModel,
      presenter: viewController
    )
    interactor.listener = listener
    return UserInfomationRouter(interactor: interactor, viewController: viewController)
  }
}
