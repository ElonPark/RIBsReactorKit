//
//  UserListViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - UserListItemViewModel

protocol UserListItemViewModel: HasUserModel, HasUUID {
  var profileImageURL: URL? { get }
  var titleWithFullName: String { get }
  var location: String { get }
}

// MARK: - UserListItemViewModelImpl

struct UserListItemViewModelImpl: UserListItemViewModel, Equatable {

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
