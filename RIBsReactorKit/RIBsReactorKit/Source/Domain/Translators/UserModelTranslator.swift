//
//  UserModelTranslator.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import CoreLocation.CLLocation
import Foundation

// MARK: - UserModelTranslator

protocol UserModelTranslator {
  func translateToUserModel(by result: [User]) -> [UserModel]
}

// MARK: - UserModelTranslatorImpl

final class UserModelTranslatorImpl: UserModelTranslator {

  func translateToUserModel(by result: [User]) -> [UserModel] {
    result.map {
      UserModel(
        gender: $0.gender,
        name: $0.name,
        email: $0.email,
        uuid: $0.login.uuid,
        dob: $0.dob,
        cell: $0.cell,
        location: $0.location,
        picture: $0.picture
      )
    }
  }
}
