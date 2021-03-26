//
//  UserInfoSectionModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

// MARK: - UserInfoSectionModel

struct UserInfoSectionModel {
  var header: UserInfoSectionHeaderViewModel?
  var hasFooter: Bool
  var items: [UserInfoSectionItem]
}

// MARK: - Equatable

extension UserInfoSectionModel: Equatable {
  static func == (lhs: UserInfoSectionModel, rhs: UserInfoSectionModel) -> Bool {
    let isEqulHeader = lhs.header?.title == rhs.header?.title
    let isEqulFooter = lhs.hasFooter == rhs.hasFooter
    let isEqulItems = lhs.items == rhs.items
    return isEqulHeader && isEqulFooter && isEqulItems
  }
}

// MARK: - SectionModelType

extension UserInfoSectionModel: SectionModelType {

  typealias Item = UserInfoSectionItem

  init(original: UserInfoSectionModel, items: [Item]) {
    self = original
  }
}

// MARK: - UserInfoSectionItem

enum UserInfoSectionItem {
  case profile(UserProfileViewModel)
  case detail(UserDetailInfoItemViewModel)
  case dummyProfile
  case dummy
}

// MARK: - Equatable

extension UserInfoSectionItem: Equatable {
  static func == (lhs: UserInfoSectionItem, rhs: UserInfoSectionItem) -> Bool {
    switch (lhs, rhs) {
    case let (.profile(lhsViewModel), .profile(rhsViewModel)):
      return lhsViewModel.uuid == rhsViewModel.uuid

    case let (.detail(lhsViewModel), .detail(rhsViewModel)):
      return lhsViewModel.uuid == rhsViewModel.uuid

    case (.dummyProfile, .dummyProfile):
      return true

    case (.dummy, .dummy):
      return true

    default:
      return false
    }
  }
}
