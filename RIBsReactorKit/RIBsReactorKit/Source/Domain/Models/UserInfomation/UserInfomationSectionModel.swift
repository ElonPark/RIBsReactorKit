//
//  UserInfomationSectionModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxDataSources

struct UserInfomationSection: Equatable {
  var header: UserInfomationSectionHeaderViewModel?
  var hasFooter: Bool
  var items: [UserInfomationSectionItem]
}

extension UserInfomationSection: SectionModelType {
  
  typealias Item = UserInfomationSectionItem
  
  init(original: UserInfomationSection, items: [Item]) {
    self = original
  }
}

enum UserInfomationSectionItem: Equatable {
  case profile(UserProfileViewModel)
  case detail(UserDetailInfomationItemViewModel)
  case dummyProfile
  case dummy
}
