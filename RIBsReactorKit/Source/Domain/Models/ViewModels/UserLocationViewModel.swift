//
//  UserLocationViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/04/19.
//  Copyright © 2021 Elon. All rights reserved.
//

import CoreLocation.CLLocation
import Foundation

struct UserLocationViewModel: HasUUID, Equatable {

  let uuid: String
  let location: Location

  init(userModel: UserModel) {
    self.uuid = userModel.uuid
    self.location = userModel.location
  }
}
