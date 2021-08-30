//
//  BirthdaySctionItemFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct BirthdaySctionItemFactory: UserInfoSectionItemFactory {

  private static let dateFormatter = DateFormatter().builder
    .dateStyle(.short)
    .timeStyle(.none)
    .build()

  private var icon: UIImage? { UIImage(systemName: "calendar") }

  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      userModel: userModel,
      icon: icon,
      title: dateFormatString(from: userModel.dob.date),
      subtitle: Strings.UserInfoTitle.birthday,
      showSeparatorLine: true
    )

    return .detail(viewModel)
  }

  private func dateFormatString(from date: Date) -> String {
    return Self.dateFormatter.string(from: date)
  }
}
