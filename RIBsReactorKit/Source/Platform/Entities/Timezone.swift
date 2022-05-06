//
// Created by Elon on 2020/04/26.
// Copyright (c) 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Timezone

struct Timezone:
  Codable,
  Equatable
{
  let offset: String
  let description: String
}
