//
//  UserListSection.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/01.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

enum UserListSectionModel: Equatable {
  case randomUser([UserListSectionItem])
}

extension UserListSectionModel: SectionModelType {
  
  typealias Item = UserListSectionItem
  
  var items: [Item] {
    switch self {
    case .randomUser(let items):
      return items
    }
  }
  
  init(original: UserListSectionModel, items: [Item]) {
    switch original {
    case .randomUser:
      self = .randomUser(items)
    }
  }
}

enum UserListSectionItem {
  case user(UserListItemViewModel)
  case dummy
}

extension UserListSectionItem: Equatable {
  static func == (lhs: UserListSectionItem, rhs: UserListSectionItem) -> Bool {
    switch (lhs, rhs) {
    case (.user(let lhsViewModel), .user(let rhsViewModel)):
      return lhsViewModel.uuid == rhsViewModel.uuid

    case (.dummy, dummy):
      return true

    default:
      return false
    }
  }
}
