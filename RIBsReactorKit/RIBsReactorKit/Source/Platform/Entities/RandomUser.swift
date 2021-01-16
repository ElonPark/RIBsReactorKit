//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - RandomUser
struct RandomUser:
  Codable,
  Equatable
{
  let results: [User]
  let info: Info
}
