//
//  DelayOption.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

import RxSwift

// MARK: - DelayOption

enum DelayOption {
  case immediate
  case constant(time: Double)
  case exponential(BackoffStrategy)
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

      case let .exponential(backoffStrategy):
        return backoffStrategy.backoff(attempt: attempt)

      case let .custom(closure):
        return closure(attempt)
      }
    }

    return .milliseconds(Int(interval * 1000))
  }
}
