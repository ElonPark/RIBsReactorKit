//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Location
struct Location: Codable {
  let street: Street
  let city: String
  let state: String
  let country: String
  let postcode: String
  let coordinates: Coordinates
  let timezone: Timezone
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    street = try container.decode(Street.self, forKey: .street)
    city = try container.decode(String.self, forKey: .city)
    state = try container.decode(String.self, forKey: .state)
    country = try container.decode(String.self, forKey: .country)
    coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
    timezone = try container.decode(Timezone.self, forKey: .timezone)
    
    if let value = try? container.decode(Int.self, forKey: .postcode) {
      postcode = String(value)
    } else {
      postcode = try container.decode(String.self, forKey: .postcode)
    }
  }
}
