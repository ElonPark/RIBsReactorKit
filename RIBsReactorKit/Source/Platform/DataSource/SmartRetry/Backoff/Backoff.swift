//
//  Backoff.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/18.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

/// [Exponential Backoff And Jitter](https://aws.amazon.com/ko/blogs/architecture/exponential-backoff-and-jitter/)
class Backoff {

  let initialDelay: Double
  let maxDelay: Double

  init(initialDelay: Double, maxDelay: Double) {
    self.initialDelay = initialDelay
    self.maxDelay = maxDelay
  }

  func exponential(attempt: Double) -> Double {
    return min(self.maxDelay, pow(2, attempt) * self.initialDelay)
  }
}
