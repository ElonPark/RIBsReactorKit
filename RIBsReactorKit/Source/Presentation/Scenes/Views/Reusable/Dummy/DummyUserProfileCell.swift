//
//  DummyUserProfileCell.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/07.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

final class DummyUserProfileCell: UserProfileCell {

  private let dummyUserTitleWithLastName = String(repeating: " ", count: 60)
  private let dummyUserFirstName = String(repeating: " ", count: 40)

  override func initUI() {
    profileBackgroundImage = nil
    userProfileImage = nil
    userTitleWithLastName = self.dummyUserTitleWithLastName
    userFirstName = self.dummyUserFirstName
    showAnimatedGradientSkeleton()
  }
}
