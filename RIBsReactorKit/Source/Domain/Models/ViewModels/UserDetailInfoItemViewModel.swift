//
//  UserDetailInfoItemViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/13.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit.UIImage

struct UserDetailInfoItemViewModel: HasUUID, Equatable {

  let uuid: String
  let icon: UIImage?
  let title: String
  let subtitle: String?
  let showSeparatorLine: Bool

  var hasSubtitle: Bool {
    guard let subtitle = subtitle else { return false }
    return !subtitle.isEmpty
  }

  init(userModel: UserModel, icon: UIImage?, title: String, subtitle: String?, showSeparatorLine: Bool) {
    self.uuid = userModel.uuid
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.showSeparatorLine = showSeparatorLine
  }
}
