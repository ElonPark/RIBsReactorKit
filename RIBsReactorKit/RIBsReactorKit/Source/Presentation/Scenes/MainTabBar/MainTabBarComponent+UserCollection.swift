//
//  MainTabBarComponent+UserCollection.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol MainTabBarDependencyUserCollection: Dependency {

}

extension MainTabBarComponent: UserCollectionDependency {
  var userCollectionViewController: UserCollectionPresentable & UserCollectionViewControllable {
    return UserCollectionViewController()
  }
}
