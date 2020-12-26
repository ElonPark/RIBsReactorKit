//
//  DelayOption.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

import RxSwift

enum DelayOption {
  case immediate
  case constant(time: Double)
  case exponential(initial: Double, multiplier: Double, maxDelay: Double = 32)
  case custom(closure: (Int) -> Double)
}

extension DelayOption {
  func makeTimeInterval(_ attempt: Int) -> RxTimeInterval {
    var interval: Double {
      switch self {
      case .immediate:
        return 0.0

      case let .constant(time):
        return time

      case let .exponential(initial, multiplier, maxDelay):
        var delay: Double {
          if attempt == 1 {
            return initial
          } else {
            let delayValue = initial * pow(multiplier, Double(attempt - 1))
            let jitter = Double.random(in: 0.5...1.5)
            return delayValue + jitter
          }
        }

        return min(maxDelay, delay)

      case let .custom(closure):
        return closure(attempt)
      }
    }

    return .milliseconds(Int(interval * 1000))
  }
}
