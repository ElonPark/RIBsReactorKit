//
//  UserListViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserListItemViewModel: HasUUID, Equatable {

  let uuid: String
  let profileImageURL: URL?
  let titleWithFullName: String
  let location: String

  init(userModel: UserModel) {
    self.uuid = userModel.uuid
    self.profileImageURL = userModel.picture.mediumImageURL
    self.titleWithFullName = "\(userModel.name.title). \(userModel.name.first) \(userModel.name.last)"
    self.location = "\(userModel.location.city) \(userModel.location.state) \(userModel.location.country)"
  }
}
