//
//  UserDetailInfomationItemViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/13.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

struct UserDetailInfomationItemViewModel: Equatable {
  
  let icon: UIImage?
  let title: String
  let subtitle: String?
  let showSeparatorLine: Bool
  
  var hasSubtitle: Bool {
    guard let subtitle = subtitle else { return false }
    return !subtitle.isEmpty
  }
}
