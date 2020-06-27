//
//  UserModelTranslator.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import CoreLocation.CLLocation

protocol UserModelTranslator {
  func translateToUserModel(by result: [User]) -> [UserModel]
}

final class UserModelTranslatorImpl: UserModelTranslator {
  
  func translateToUserModel(by result: [User]) -> [UserModel] {
    return result.map {
      UserModel(
        gender: $0.gender,
        name: $0.name,
        email: $0.email,
        login: $0.login,
        dob: $0.dob,
        phone: $0.phone,
        cell: $0.cell,
        id: $0.id,
        nat: $0.nat,
        location: $0.location,
        coordinates: self.coordinates(from: $0.location),
        largeImageURL: URL(string: $0.picture.large),
        mediumImageURL: URL(string: $0.picture.medium),
        thumbnailImageURL: URL(string: $0.picture.thumbnail)
      )
    }
  }
  
  private func coordinates(from location: Location) -> CLLocationCoordinate2D? {
    guard let latitude = Double(location.coordinates.latitude),
      let longitude = Double(location.coordinates.longitude) else {
        return nil
    }
    
    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}
