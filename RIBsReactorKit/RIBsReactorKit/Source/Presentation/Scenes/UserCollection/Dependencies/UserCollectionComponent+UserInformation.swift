//
//  UserCollectionComponent+UserInformation.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/11/13.
//  Copyright © 2021 Elon. All rights reserved.
//

import RIBs

protocol UserCollectionDependencyUserInformation: Dependency {}

// MARK: - UserCollectionComponent + UserInformationDependency

extension UserCollectionComponent: UserInformationDependency {
  var selectedUserModelStream: SelectedUserModelStream {
    mutableSelectedUserModelStream
  }
}
