//
//  UserListPresentableState.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/05.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserListPresentableState: Equatable {
  var isLoading: Bool = false
  var isRefresh: Bool = false
  var userListSections = [UserListSectionModel]()
}
