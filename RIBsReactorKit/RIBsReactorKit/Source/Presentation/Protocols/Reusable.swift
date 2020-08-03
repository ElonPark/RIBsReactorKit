//
//  Reusable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

protocol Reusable {
  static var identifier: String { get }
}

extension Reusable {
  static var identifier: String {
    return String(describing: Self.self)
  }
}
