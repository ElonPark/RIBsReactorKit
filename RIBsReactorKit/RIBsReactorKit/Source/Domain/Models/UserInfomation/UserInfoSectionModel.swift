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

// MARK: - CustomStringConvertible

extension UserInfoSectionItem: CustomStringConvertible {
  var description: String {
    switch self {
    case let .profile(viewModel):
      return "item: profile, title: \(viewModel.titleWithLastName)"
    case let .detail(viewModel):
      return "item: detail, title: \(viewModel.title), subtitle: \(viewModel.subtitle ?? "nil")"
    case let .location(viewModel):
      return "item: location, location: \(viewModel.location)"
    case .dummyProfile:
      return "item: dummyProfile"
    case .dummy:
      return "item: dummy"
    }
  }
}
