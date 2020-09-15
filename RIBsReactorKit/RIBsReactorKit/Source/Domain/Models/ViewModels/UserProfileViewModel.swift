//
//  UserProfileViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserProfileViewModel: Equatable {
  
  let userModel: UserModel
  
  var profileBackgroundImageURL: URL? {
    userModel.largeImageURL
  }
  
  var profileImageURL: URL? {
    userModel.mediumImageURL
  }
  
  var titleWithLastName: String {
    "\(userModel.name.title). \(userModel.name.last)"
  }
  
  var firstName: String {
    userModel.name.first
  }
}
