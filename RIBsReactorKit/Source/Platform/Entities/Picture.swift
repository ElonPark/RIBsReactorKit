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

  var largeImageURL: URL? { URL(string: self.large) }
  var mediumImageURL: URL? { URL(string: self.medium) }
  var thumbnailImageURL: URL? { URL(string: self.thumbnail) }
}
