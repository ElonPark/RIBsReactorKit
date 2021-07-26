//
//  LocationSectionFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/04/19.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

struct LocationSectionFactory: UserInfoSectionFactory {

  func makeSection(from userModel: UserModel) -> UserInfoSectionModel {
    let viewModel = UserLocationViewModel(userModel: userModel)
    let item: UserInfoSectionItem = .location(viewModel)

    let section = UserInfoSectionModel(
      header: nil,
      hasFooter: true,
      items: [item]
    )

    return section
  }
}
