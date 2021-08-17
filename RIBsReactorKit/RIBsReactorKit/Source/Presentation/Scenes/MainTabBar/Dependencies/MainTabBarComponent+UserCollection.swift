//
//  MainTabBarComponent+UserCollection.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

// MARK: - MainTabBarDependencyUserCollection

protocol MainTabBarDependencyUserCollection: Dependency {
  var userCollectionViewController: UserCollectionViewControllable { get }
}

// MARK: - MainTabBarComponent + UserCollectionDependency

extension MainTabBarComponent: UserCollectionDependency {
  var userCollectionViewController: UserCollectionViewControllable {
    dependency.userCollectionViewController
  }
}
