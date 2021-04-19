//
//  UserLocationViewModel.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/04/19.
//  Copyright © 2021 Elon. All rights reserved.
//

import CoreLocation.CLLocation
import Foundation

struct UserLocationViewModel: HasUserModel, HasUUID, Equatable {

  let userModel: UserModel

  var location: Location { userModel.location }
}
