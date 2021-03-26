//
//  UserModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/20.
//  Copyright © 2020 Elon. All rights reserved.
//

import CoreLocation.CLLocation
import Foundation

struct UserModel {
  let gender: String
  let name: Name
  let email: String
  let login: Login
  let dob: Dob
  let phone: String
  let cell: String
  let id: ID
  let nat: String
  let location: Location
  let coordinates: CLLocationCoordinate2D?
  let largeImageURL: URL?
  let mediumImageURL: URL?
  let thumbnailImageURL: URL?
}

extension UserModel: Equatable {
  static func == (lhs: UserModel, rhs: UserModel) -> Bool {
    lhs.login.uuid == rhs.login.uuid
  }
}
