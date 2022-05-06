//
//  SmartRetry.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Reachability
import RxReachability
import RxRelay
import RxSwift

extension PrimitiveSequence {
  /**
   Retries the source observable sequence on error using a provided retry
   strategy.
     - parameter maxAttemptCount: Maximum number of times to repeat the sequence. `5` by default.
   reachabilityChanged
     - parameter delayOption: DelayOptions.
     - parameter didBecomeReachable: Trigger which is fired when network connection becomes reachable
        with random delay.
       `Reachability.rx.isConnected` by default.
     - parameter shouldRetry: Always return `true` by default.
   */
  func retry(
    _ maxAttemptCount: Int = 5,
    delayOption: DelayOption,
    didBecomeReachable: Observable<Void> = Reachability.rx.isConnected,
    shouldRetry: @escaping (Error) -> Bool = { _ in true }
  ) -> PrimitiveSequence<Trait, Element> {
    return retry { errors in
      return errors
        .enumerated()
        .flatMap { attempt, error -> Observable<Void> in
          let attemptCount = attempt + 1
          guard maxAttemptCount > attemptCount, shouldRetry(error) else { return .error(error) }

          let delay = delayOption.makeTimeInterval(attemptCount)

          let timer = Observable<Int>.timer(delay, scheduler: MainScheduler.instance)
            .map { _ in Void() }

          let networkConnected = didBecomeReachable
            .delay(delay, scheduler: MainScheduler.instance)
            .map { _ in Void() }

          return Observable.merge(timer, networkConnected)
        }
    }
  }
}
