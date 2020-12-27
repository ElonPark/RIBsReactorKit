//
//  UserListViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol UserListItemViewModel {
  var userModel: UserModel { get }
  var uuid: String { get }
  var profileImageURL: URL? { get }
  var titleWithFullName: String { get }
  var location: String { get }
}

struct UserListItemViewModelImpl: UserListItemViewModel, Equatable {

  let userModel: UserModel

  var uuid: String {
    userModel.login.uuid
  }

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
