//
//  DummyUserListItemCell.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/07.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

final class DummyUserListItemCell: UserListItemCell {

  private let dummyUserName = String(repeating: " ", count: 60)
  private let dummyUserLocation = String(repeating: " ", count: 40)

  override func initUI() {
    super.initUI()
    userProfileImage = nil
    userName = self.dummyUserName
    userLocation = self.dummyUserLocation
    showAnimatedGradientSkeleton()
  }
}
