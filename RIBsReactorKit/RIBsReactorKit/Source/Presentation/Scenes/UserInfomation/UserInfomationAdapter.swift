//
//  UserInfomationAdapter.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserInfomationAdapterListener: class {
  func dettachUserInfomationRIB()
}

final class UserInfomationAdapterComponent: UserInfomationDependency {
  
  let userModel: UserModel
  
  init(userModel: UserModel) {
    self.userModel = userModel
  }
}

protocol UserInfomationAdapterBuildable: Buildable {
  func build(
    userModel: UserModel,
    withListener listener: UserInfomationAdapterListener
  ) -> UserInfomationRouting
}

final class UserInfomationAdapter:
  UserInfomationAdapterBuildable,
  UserInfomationListener
{
  
  // MARK: - Properties

  private weak var listener: UserInfomationAdapterListener?
  
  // MARK: - Initialization & Deinitialization

  init() {}
  
  // MARK: - Internal methods

  func build(
    userModel: UserModel,
    withListener listener: UserInfomationAdapterListener
  ) -> UserInfomationRouting {
    let component = UserInfomationAdapterComponent(userModel: userModel)
    let userInfomationBuilder = UserInfomationBuilder(dependency: component)
    self.listener = listener
    return userInfomationBuilder.build(withListener: self)
  }
}

// MARK: - UserInfomationListener
extension UserInfomationAdapter {
  func dettachUserInfomationRIB() {
    listener?.dettachUserInfomationRIB()
  }
}
