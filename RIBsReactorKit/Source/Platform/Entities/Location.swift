//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Location

struct Location:
  Codable,
  Equatable
{
  let street: Street
  let city: String
  let state: String
  let country: String
  let postcode: String
  let coordinates: Coordinates
  let timezone: Timezone

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.street = try container.decode(Street.self, forKey: .street)
    self.city = try container.decode(String.self, forKey: .city)
    self.state = try container.decode(String.self, forKey: .state)
    self.country = try container.decode(String.self, forKey: .country)
    self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
    self.timezone = try container.decode(Timezone.self, forKey: .timezone)

    if let value = try? container.decode(Int.self, forKey: .postcode) {
      self.postcode = String(value)
    } else {
      self.postcode = try container.decode(String.self, forKey: .postcode)
    }
  }
}
