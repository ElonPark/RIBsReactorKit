//
//  UserProfileViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/17.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol UserProfileViewModel {
  var uuid: String { get }
  var profileBackgroundImageURL: URL? { get }
  var profileImageURL: URL? { get }
  var titleWithLastName: String { get }
  var firstName: String { get }
}

struct UserProfileViewModelImpl: UserProfileViewModel, Equatable {

  var uuid: String {
    userModel.login.uuid
  }
  
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

  private let userModel: UserModel

  init(userModel: UserModel) {
    self.userModel = userModel
  }
}
