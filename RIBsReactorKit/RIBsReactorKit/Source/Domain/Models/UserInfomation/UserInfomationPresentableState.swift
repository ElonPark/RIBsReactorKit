//
//  UserInfomationPresentableState.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/19.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserInfomationPresentableState: Equatable {
  var userModel: UserModel
  var userInfomationSections = [UserInfomationSection]()
}
