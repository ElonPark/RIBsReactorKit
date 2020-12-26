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
        with random delay 500ms ~ 1500ms.
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
          guard shouldRetry(error), maxAttemptCount > attempt + 1 else { return .error(error) }

          let timer = Observable<Int>.timer(
            delay.makeTimeInterval(attempt + 1),
            scheduler: MainScheduler.instance
          )
          .map { _ in Void() }

          let jitter = Int.random(in: 500...1500)
          let networkConnected = didBecomeReachable
            .delay(.milliseconds(jitter), scheduler: MainScheduler.instance)
            .map { _ in Void() }

          return Observable.merge(timer, networkConnected)
      }
    }
  }
}
