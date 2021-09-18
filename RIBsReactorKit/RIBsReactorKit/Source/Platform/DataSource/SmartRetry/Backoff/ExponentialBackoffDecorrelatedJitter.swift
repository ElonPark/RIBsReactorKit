//
//  ExponentialBackoffDecorrelatedJitter.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/18.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

final class ExponentialBackoffDecorrelatedJitter: Backoff, BackoffStrategy {

  var delay: Double

  override init(initialDelay: Double, maxDelay: Double) {
    self.delay = initialDelay
    super.init(initialDelay: initialDelay, maxDelay: maxDelay)
  }

  func backoff(attempt: Int) -> Double {
    delay = min(maxDelay, Double.random(in: initialDelay...delay * 3))
    return delay
  }
}
