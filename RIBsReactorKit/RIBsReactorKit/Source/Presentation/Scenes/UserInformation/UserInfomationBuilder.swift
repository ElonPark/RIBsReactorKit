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
  
  private var userModel: UserModel { dependency.userModel }
  
  fileprivate var initialState: UserInfomationPresentableState {
    UserInfomationPresentableState(userModel: userModel)
  }
  
  fileprivate var userInfomationSectionFactories: [UserInfomationSectionFactory] {
    [
      ProfileSectionFactory(),
      BasicInfomationSectionFactory()
    ]
  }
  
  fileprivate var userInfomationSectionListFactory: UserInfomationSectionListFactory {
    UserInfomationSectionListFactoryImpl(userModel: userModel)
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
  
  override init(dependency: UserInfomationDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: UserInfomationListener) -> UserInfomationRouting {
    let component = UserInfomationComponent(dependency: dependency)
    let viewController = UserInfomationViewController()
    let interactor = UserInfomationInteractor(
      initialState: component.initialState,
      userInfomationSectionFactories: component.userInfomationSectionFactories,
      userInfomationSectionListFactory: component.userInfomationSectionListFactory,
      presenter: viewController
    )
    interactor.listener = listener
    return UserInfomationRouter(interactor: interactor, viewController: viewController)
  }
}
