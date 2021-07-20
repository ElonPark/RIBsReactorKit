//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Coordinates

struct Coordinates: Codable, Equatable {
  let latitude: String
  let longitude: String

  var locationCoordinate2D: Coordinate2D? {
    guard let latitude = Double(latitude),
          let longitude = Double(longitude)
    else { return nil }

    return Coordinate2D(latitude: latitude, longitude: longitude)
  }
}
