//
//  ExponentialBackoffFullJitter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/18.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

final class ExponentialBackoffFullJitter: Backoff, BackoffStrategy {

  func backoff(attempt: Int) -> Double {
    let delay = exponential(attempt: Double(attempt))
    return Double.random(in: 0...delay)
  }
}
