//
//  NetworkError.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/18.
//  Copyright © 2021 Elon. All rights reserved.
//

import Alamofire
import Moya

final class NetworkError {

  let error: Error

  var moyaError: MoyaError? {
    self.error as? MoyaError
  }

  var moyaUnderlyingError: Error? {
    guard case let .underlying(underlyingError, _) = self.moyaError else { return nil }
    return underlyingError
  }

  var isMoyaUnderlyingError: Bool {
    self.moyaUnderlyingError != nil
  }

  var afError: AFError? {
    guard let moyaUnderlyingError = moyaUnderlyingError else { return self.error.asAFError }
    return moyaUnderlyingError.asAFError
  }

  var afUnderlyingError: Error? {
    self.afError?.underlyingError
  }

  var urlError: URLError? {
    self.afUnderlyingError as? URLError
  }

  init(error: Error) {
    self.error = error
  }

  func afErrorDebugDescriptions() -> [String] {
    guard let afError = self.afError else { return [] }

    var messages = [String]()

    if let responseCode = afError.responseCode {
      messages.append("Response Code: \(responseCode)")
    }
    if let responseContentType = afError.responseContentType {
      messages.append("Response Content Type: \(responseContentType)")
    }
    if let failureReason = afError.failureReason {
      messages.append("Failure Reason: \(failureReason)")
    }
    if let recoverySuggestion = afError.recoverySuggestion {
      messages.append("Recovery Suggestion: \(recoverySuggestion)")
    }
    if let contentType = afError.responseContentType {
      messages.append("Content Type: \(contentType)")
    }
    if let errorDescription = afError.errorDescription {
      messages.append("Description: \(errorDescription)")
    }

    return messages
  }

  func urlErrorDebugDescriptions() -> [String] {
    guard let urlError = self.urlError else { return [] }

    var messages = [String]()

    if let urlString = urlError.failureURLString {
      messages.append("Failure URLString: \(urlString)")
    }

    return messages
  }

  func responseString() -> String? {
    guard let response = moyaError?.response else { return nil }

    if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
      return "\(jsonObject)"
    } else if let rawString = String(data: response.data, encoding: .utf8) {
      return "\(rawString)"
    }

    return nil
  }
}
