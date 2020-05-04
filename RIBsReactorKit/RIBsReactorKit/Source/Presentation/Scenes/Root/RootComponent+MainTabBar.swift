//
//  RootComponent+MainTabBar.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol RootDependencyMainTabBar: Dependency {
  
}

extension RootComponent: MainTabBarDependency {
  var userListViewController: UserListPresentable & UserListViewControllable {
    return UserListViewController()
  }
  
  var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable {
    return UserCollectionViewController()
  }
}
