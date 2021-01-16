//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Picture
struct Picture:
  Codable,
  Equatable
{
  let large: String
  let medium: String
  let thumbnail: String
}
