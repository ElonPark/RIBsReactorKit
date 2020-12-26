//
//  UserInfoSectionModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

struct UserInfoSectionModel: Equatable {
  var header: UserInfoSectionHeaderViewModel?
  var hasFooter: Bool
  var items: [UserInfoSectionItem]
}

extension UserInfoSectionModel: SectionModelType {
  
  typealias Item = UserInfoSectionItem
  
  init(original: UserInfoSectionModel, items: [Item]) {
    self = original
  }
}

enum UserInfoSectionItem {
  case profile(UserProfileViewModel)
  case detail(UserDetailInfoItemViewModel)
  case dummyProfile
  case dummy
}

extension UserInfoSectionItem: Equatable {
  static func == (lhs: UserInfoSectionItem, rhs: UserInfoSectionItem) -> Bool {
    switch (lhs, rhs) {
    case (.profile(let lhsViewModel), .profile(let rhsViewModel)):
      return lhsViewModel.uuid == rhsViewModel.uuid

    case (.detail, .detail):
      return true
    case (.dummyProfile, .dummyProfile):
      return true
    case (.dummy, .dummy):
      return true
    default:
      return false
    }
  }
}
