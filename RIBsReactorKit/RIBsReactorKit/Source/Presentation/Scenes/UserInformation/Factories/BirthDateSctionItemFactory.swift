//
//  BirthDateSctionItemFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct BirthDateSctionItemFactory: UserInfoSectionItemFactory {

  private var icon: UIImage? {
    guard #available(iOS 13, *) else { return nil }
    return UIImage(systemName: "calendar")
  }

  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel: UserDetailInfoItemViewModel = UserDetailInfoItemViewModelImpl(
      userModel: userModel,
      icon: icon,
      title: dateFormatString(from: userModel.dob.date),
      subtitle: "생일",
      showSeparatorLine: true
    )

    return .detail(viewModel)
  }

  private func dateFormatString(from date: Date) -> String {
    let dateFormatter = DateFormatter().then {
      $0.dateStyle = .short
      $0.timeStyle = .none
    }
    return dateFormatter.string(from: date)
  }
}
