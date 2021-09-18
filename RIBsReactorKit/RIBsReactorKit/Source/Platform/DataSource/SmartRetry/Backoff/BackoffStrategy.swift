//
//  BackoffStrategy.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/18.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

protocol BackoffStrategy {
  func backoff(attempt: Int) -> Double
}
