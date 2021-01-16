//
//  ISO8601DateFormatter+Extensios.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

extension Formatter {
  static let iso8601withFractionalSeconds = ISO8601DateFormatter().then {
    $0.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
  }
}

extension JSONDecoder.DateDecodingStrategy {
  static let iso8601withFractionalSeconds = custom {
    let container = try $0.singleValueContainer()
    let string = try container.decode(String.self)
    
    guard let date = Formatter.iso8601withFractionalSeconds.date(from: string) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
    return date
  }
}

extension JSONEncoder.DateEncodingStrategy {
  static let iso8601withFractionalSeconds = custom {
    var container = $1.singleValueContainer()
    try container.encode(Formatter.iso8601withFractionalSeconds.string(from: $0))
  }
}
