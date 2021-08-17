//
//  UserListComponent+UserInformation.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/19.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs

protocol UserListDependencyUserInformation: Dependency {}

// MARK: - UserListComponent + UserInformationDependency

extension UserListComponent: UserInformationDependency {
  var selectedUserModelStream: SelectedUserModelStream {
    mutableSelectedUserModelStream
  }
}
