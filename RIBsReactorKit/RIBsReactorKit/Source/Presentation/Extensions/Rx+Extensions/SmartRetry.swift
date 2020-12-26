//
//  SmartRetry.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Reachability
import RxReachability
import RxSwift
import RxRelay

extension PrimitiveSequence {
  /**
   Retries the source observable sequence on error using a provided retry
   strategy.
     - parameter maxAttemptCount: Maximum number of times to repeat the sequence. `Int.max` by default.
   reachabilityChanged
     - parameter delay: DelayOptions.
     - parameter didBecomeReachable: Trigger which is fired when network connection becomes reachable
        with random delay.
       `Reachability.rx.isConnected` by default.
     - parameter shouldRetry: Always retruns `true` by default.
   */
  func retry(
    _ maxAttemptCount: Int = Int.max,
    delay: DelayOption,
    didBecomeReachable: Observable<Void> = Reachability.rx.isConnected,
    shouldRetry: @escaping (Error) -> Bool = { _ in true }
  ) -> PrimitiveSequence<Trait, Element> {
    return retryWhen { errors in
      return errors
        .enumerated()
        .flatMap { attempt, error -> Observable<Void> in
          let attemptCount = attempt + 1
          guard shouldRetry(error), maxAttemptCount > attemptCount else { return .error(error) }

          let fullJitter = delay.makeTimeInterval(attemptCount)

          let timer = Observable<Int>.timer(fullJitter, scheduler: MainScheduler.instance)
          .map { _ in Void() }

          let networkConnected = didBecomeReachable
            .delay(fullJitter, scheduler: MainScheduler.instance)
            .map { _ in Void() }

          return Observable.merge(timer, networkConnected)
      }
    }
  }
}
