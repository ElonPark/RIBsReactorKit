//
//  UserProfileViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserProfileViewModel: HasUserModel, HasUUID, Equatable {

  let userModel: UserModel

  let profileBackgroundImageURL: URL?
  let profileImageURL: URL?

  var titleWithLastName: String { "\(userModel.name.title). \(userModel.name.last)" }
  var firstName: String { userModel.name.first }

  init(userModel: UserModel) {
    self.userModel = userModel
    self.profileBackgroundImageURL = userModel.picture.thumbnailImageURL
    self.profileImageURL = userModel.picture.largeImageURL
  }
}
