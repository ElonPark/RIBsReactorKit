//
//  UserModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/20.
//  Copyright © 2020 Elon. All rights reserved.
//

import CoreLocation.CLLocation
import Foundation

// MARK: - UserModel

struct UserModel {
  let gender: String
  let name: Name
  let email: String
  let uuid: String
  let dob: Dob
  let cell: String
  let location: Location
  let picture: Picture
}

// MARK: - Equatable

extension UserModel: Equatable {
  static func == (lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
