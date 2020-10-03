//
//  UserListViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

struct UserListItemViewModel: Equatable {
  
  let userModel: UserModel
  
  var profileImageURL: URL? {
    userModel.thumbnailImageURL
  }
  
  var titleWithFullName: String {
    "\(userModel.name.title). \(userModel.name.first) \(userModel.name.last)"
  }
  
  var location: String {
    "\(userModel.location.city) \(userModel.location.state) \(userModel.location.country)"
  }
}
