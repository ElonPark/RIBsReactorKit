//
//  UserListSection.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/01.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

// MARK: - UserListSectionModel

enum UserListSectionModel: Equatable {
  case randomUser([UserListSectionItem])
}

// MARK: - SectionModelType

extension UserListSectionModel: SectionModelType {

  typealias Item = UserListSectionItem

  var items: [Item] {
    switch self {
    case let .randomUser(items):
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

// MARK: - UserListSectionItem

enum UserListSectionItem: Equatable {
  case user(UserListItemViewModel)
  case dummy
}
