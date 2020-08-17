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
  
  var items: [UserListSectionItem] {
    switch self {
    case .randomUser(let items):
      return items
    }
  }
  
  init(original: UserListSectionModel, items: [UserListSectionItem]) {
    switch original {
    case .randomUser:
      self = .randomUser(items)
    }
  }
}

enum UserListSectionItem: Equatable {
  case user(UserListViewModel)
  case dummy
}
