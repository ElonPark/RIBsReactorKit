//
//  UserListState.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/05.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserListState {
  //// FIXME: - 수정 필요 2020-05-05 00:54:59
  var isLoading: Bool = false
  var items: [UserModel] = []
  var selectedItem: IndexPath?
}
