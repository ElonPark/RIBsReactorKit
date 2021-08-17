//
//  Info.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

// MARK: - Info

struct Info:
  Codable,
  Equatable
{
  let seed: String
  let results: Int
  let page: Int
  let version: String
}
