//
//  ProfileSectionFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

struct ProfileSectionFactory: UserInfomationSectionFactory {
  func makeSection(from userModel: UserModel) -> UserInfomationSection {
    let viewModel = UserProfileViewModel(userModel: userModel)
    let item: UserInfomationSectionItem = .profile(viewModel)
    
    let section = UserInfomationSection(
      header: nil,
      hasFooter: true,
      items: [item]
    )
    
    return section
  }
}
