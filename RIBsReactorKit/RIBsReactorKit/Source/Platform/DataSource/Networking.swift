//
//  Networking.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import Alamofire
import Moya
import RxMoya
import RxSwift

final class Networking<Target: TargetType>: MoyaProvider<Target> {
  
  func request(
    _ target: Target,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
  ) -> Single<Response> {
    let requestString = "\(target.method.rawValue) \(target.path)"
    
    return self.rx.request(target)
      .filterSuccessfulStatusCodes()
      .do(onSuccess: { response in
        let message = "SUCCESS: \(requestString) (\(response.description))"
        Log.debug(fileName: file, line: line, funcName: function, message)
      }, onError: { [weak self] error in
        let message = "FAILURE: \(requestString)"
        if let this = self {
          this.loggingError(
            file: file,
            line: line,
            function: function,
            message: message,
            error: error
          )
        } else {
          Log.warning(
            fileName: file,
            line: line,
            funcName: function,
            message,
            error.localizedDescription,
            error
          )
        }
        }, onSubscribed: {
          let message = "REQUEST: \(requestString)"
          Log.debug(fileName: file, line: line, funcName: function, message)
      })
  }
  
  private func loggingError(
    file: String,
    line: UInt,
    function: String,
    message: String,
    error: Error
  ) {
    var message = message
    
    let afError = loggingAFError(message: message, error: error)
    message = afError.message
    
    let isLoggingMoyaError = self.isLoggingMoyaError(
      file: file,
      line: line,
      function: function,
      hasStatusCode: afError.hasStatusCode,
      message: message,
      error: error
    )
    
    if !isLoggingMoyaError {
      Log.warning(
        fileName: file,
        line: line,
        funcName: function,
        message,
        error.localizedDescription,
        error
      )
    }
  }
  
  private func loggingAFError(
    message: String,
    error: Error
  ) -> (message: String, hasStatusCode: Bool)  {
    var hasStatusCode: Bool = false
    guard let afError = error.asAFError else { return (message, hasStatusCode) }
    var message = message
    
    if let responseCode = afError.responseCode {
      message += " Status Code: \(responseCode)"
      hasStatusCode = true
    }
    if let failureReason = afError.failureReason {
      message += "\nFailure Reason: \(failureReason)"
    }
    if let recoverySuggestion = afError.recoverySuggestion {
      message += "\nRecovery Suggestion: \(recoverySuggestion)"
    }
    if let contentType = afError.responseContentType {
      message += "\nContent Type: \(contentType)"
    }
    if let errorDescription = afError.errorDescription {
      message += "\nDescription: \(errorDescription)"
    }
    
    message += "\n\(afError.localizedDescription)"
    
    return (message, hasStatusCode)
  }
  
  private func isLoggingMoyaError(
    file: String,
    line: UInt,
    function: String,
    hasStatusCode: Bool,
    message: String,
    error: Error
  ) -> Bool {
    guard let moyaError = error as? MoyaError,
      let response = moyaError.response else {
        return false
    }
    
    var message = message
    
    if !hasStatusCode {
      message += "\nResponse Description: \(response.debugDescription)"
    }
    
    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
      Log.warning(
        fileName: file,
        line: line,
        funcName: function,
        message,
        "RESPONSE DATA: \(jsonObject)",
        error
      )
    } else {
      let rawString = String(data: response.data, encoding: .utf8) ?? "nil"
      Log.warning(
        fileName: file,
        line: line,
        funcName: function,
        message,
        "Raw String: \(rawString)",
        error
      )
    }
    
    return true
  }
}
