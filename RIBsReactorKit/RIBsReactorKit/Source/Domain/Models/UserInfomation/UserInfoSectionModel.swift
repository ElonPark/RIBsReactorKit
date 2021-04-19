//
//  UserInfoSectionModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

// MARK: - UserInfoSectionModel

struct UserInfoSectionModel: Equatable {
  var header: UserInfoSectionHeaderViewModel?
  var hasFooter: Bool
  var items: [UserInfoSectionItem]
}

// MARK: - SectionModelType

extension UserInfoSectionModel: SectionModelType {

  typealias Item = UserInfoSectionItem

  init(original: UserInfoSectionModel, items: [Item]) {
    self = original
  }
}

// MARK: - UserInfoSectionItem

enum UserInfoSectionItem: Equatable {
  case profile(UserProfileViewModel)
  case detail(UserDetailInfoItemViewModel)
  case location(UserLocationViewModel)
  case dummyProfile
  case dummy
}
