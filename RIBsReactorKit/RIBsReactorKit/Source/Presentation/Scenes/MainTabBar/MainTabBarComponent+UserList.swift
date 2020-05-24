//
//  MainTabBarComponent+UserList.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol MainTabBarDependencyUserList: Dependency {

}

extension MainTabBarComponent: UserListDependency {
  var userListViewController: UserListPresentable & UserListViewControllable {
    return UserListViewController()
  }
}
