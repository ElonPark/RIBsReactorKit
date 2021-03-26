//
//  UserProfileViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol UserProfileViewModel: HasUserModel, HasUUID {
  var profileBackgroundImageURL: URL? { get }
  var profileImageURL: URL? { get }
  var titleWithLastName: String { get }
  var firstName: String { get }
}

struct UserProfileViewModelImpl: UserProfileViewModel, Equatable {

  let userModel: UserModel

  var profileBackgroundImageURL: URL? {
    userModel.thumbnailImageURL
  }

  var profileImageURL: URL? {
    userModel.largeImageURL
  }

  var titleWithLastName: String {
    "\(userModel.name.title). \(userModel.name.last)"
  }

  var firstName: String {
    userModel.name.first
  }
}
