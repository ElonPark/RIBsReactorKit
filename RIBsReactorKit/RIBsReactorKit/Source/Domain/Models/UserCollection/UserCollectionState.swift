//
//  UserCollectionState.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/16.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

// MARK: - UserCollectionState

struct UserCollectionState {
  var isLoading = false
  var isRefresh = false
  var userModels = [UserModel]()
}
