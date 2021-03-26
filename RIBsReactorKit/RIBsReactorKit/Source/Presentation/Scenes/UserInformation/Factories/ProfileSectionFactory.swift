//
//  ProfileSectionFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

struct ProfileSectionFactory: UserInfoSectionFactory {
  func makeSection(from userModel: UserModel) -> UserInfoSectionModel {
    let viewModel: UserProfileViewModel = UserProfileViewModelImpl(userModel: userModel)
    let item: UserInfoSectionItem = .profile(viewModel)

    let section = UserInfoSectionModel(
      header: nil,
      hasFooter: true,
      items: [item]
    )

    return section
  }
}
