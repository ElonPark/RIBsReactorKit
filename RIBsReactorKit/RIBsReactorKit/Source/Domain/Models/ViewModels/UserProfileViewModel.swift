//
//  UserProfileViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserProfileViewModel: HasUUID, Equatable {

  let uuid: String
  let profileBackgroundImageURL: URL?
  let profileImageURL: URL?
  let titleWithLastName: String
  let firstName: String

  init(userModel: UserModel) {
    self.uuid = userModel.uuid
    self.profileBackgroundImageURL = userModel.picture.thumbnailImageURL
    self.profileImageURL = userModel.picture.largeImageURL
    self.titleWithLastName = "\(userModel.name.title). \(userModel.name.last)"
    self.firstName = userModel.name.first
  }
}
