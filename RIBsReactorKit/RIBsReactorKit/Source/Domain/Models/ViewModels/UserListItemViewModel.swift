//
//  UserListViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserListItemViewModel: HasUserModel, HasUUID, Equatable {

  let userModel: UserModel

  let profileImageURL: URL?

  var titleWithFullName: String { "\(userModel.name.title). \(userModel.name.first) \(userModel.name.last)" }
  var location: String { "\(userModel.location.city) \(userModel.location.state) \(userModel.location.country)" }

  init(userModel: UserModel) {
    self.userModel = userModel
    self.profileImageURL = userModel.picture.mediumImageURL
  }
}
