//
//  Networking.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import Alamofire
import Moya
import RxSwift

final class Networking<Target: TargetType>: MoyaProvider<Target> {

  func request(
    _ target: Target,
    withRetry needRetry: Bool = true,
    retryCount: Int = 3,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
  ) -> Single<Response> {
    #if DEBUG
      let requestString = "\(target.method.rawValue) \(target.path)"
      let request = rx.request(target)
        .do(onSuccess: { response in
          let message = "SUCCESS: \(requestString) (\(response.description))"
          Log.debug(fileName: file, line: line, funcName: function, message)
        }, onError: { error in
          let message = "FAILURE: \(requestString)\n\(Self.logging(error: error))"
          Log.warning(fileName: file, line: line, funcName: function, message)

        }, onSubscribed: {
          let message = "REQUEST: \(requestString)"
          Log.debug(fileName: file, line: line, funcName: function, message)
        })

      if needRetry {
        let backoffStrategy = ExponentialBackoffDecorrelatedJitter(initialDelay: 1.0, maxDelay: 120.0)
        return request.retry(retryCount, delayOption: .exponential(backoffStrategy))
      } else {
        return request
      }

    #else
      if needRetry {
        let backoffStrategy = ExponentialBackoffDecorrelatedJitter(initialDelay: 1.0, maxDelay: 120.0)
        return rx.request(target).retry(retryCount, delayOption: .exponential(backoffStrategy))
      } else {
        return rx.request(target)
      }
    #endif
  }

  private static func logging(error: Error) -> String {
    let networkError = NetworkError(error: error)
    guard let moyaError = networkError.moyaError else { return error.localizedDescription }

    var messages = [String]()

    if !networkError.isMoyaUnderlyingError, let errorDescription = moyaError.errorDescription {
      messages.append("Moya Error Description: \(errorDescription)")
    }

    messages.append(networkError.afErrorDebugDescriptions().joined(separator: "\n"))
    messages.append(networkError.urlErrorDebugDescriptions().joined(separator: "\n"))

    if let responseString = networkError.responseString() {
      messages.append(responseString)
    }

    return messages.joined(separator: "\n")
  }
}
