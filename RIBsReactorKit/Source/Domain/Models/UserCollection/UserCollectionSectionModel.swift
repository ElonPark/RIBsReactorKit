//
//  UserCollectionSectionModel.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

import RxDataSources

// MARK: - UserCollectionSectionModel

enum UserCollectionSectionModel: Equatable {
  case randomUser([UserCollectionSectionItem])
}

// MARK: - SectionModelType

extension UserCollectionSectionModel: SectionModelType {

  typealias Item = UserCollectionSectionItem

  var items: [Item] {
    switch self {
    case let .randomUser(items):
      return items
    }
  }

  init(original: UserCollectionSectionModel, items: [Item]) {
    switch original {
    case .randomUser:
      self = .randomUser(items)
    }
  }
}

// MARK: - UserCollectionSectionItem

enum UserCollectionSectionItem: Equatable {
  case user(UserProfileViewModel)
  case dummy
}
