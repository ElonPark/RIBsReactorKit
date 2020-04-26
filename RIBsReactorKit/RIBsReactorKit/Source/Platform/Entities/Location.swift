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
  let postcode: Int
  let coordinates: Coordinates
  let timezone: Timezone
}
