//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Login
struct Login: Codable {
  let uuid: String
  let username: String
  let password: String
  let salt: String
  let md5: String
  let sha1: String
  let sha256: String
}
