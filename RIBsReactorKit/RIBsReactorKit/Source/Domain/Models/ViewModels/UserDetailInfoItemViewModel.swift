//
//  UserDetailInfoItemViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/13.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

protocol UserDetailInfoItemViewModel {
  var icon: UIImage? { get }
  var title: String { get }
  var subtitle: String? { get }
  var showSeparatorLine: Bool { get }
  var hasSubtitle: Bool { get }
  var uuid: String { get }
}

struct UserDetailInfoItemViewModelImpl: UserDetailInfoItemViewModel, Equatable {

  let icon: UIImage?
  let title: String
  let subtitle: String?
  let showSeparatorLine: Bool

  var hasSubtitle: Bool {
    guard let subtitle = subtitle else { return false }
    return !subtitle.isEmpty
  }

  var uuid: String {
    userModel.login.uuid
  }

  private let userModel: UserModel

  init(
    userModel: UserModel,
    icon: UIImage?,
    title: String,
    subtitle: String?,
    showSeparatorLine: Bool
  ) {
    self.userModel = userModel
    self.icon = icon
    self.title = title
    self.subtitle = subtitle
    self.showSeparatorLine = showSeparatorLine
  }
}
