//
//  RandomUserService.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Moya

// MARK: - RandomUserService

enum RandomUserService: TargetType {
  case multipleUsers(resultCount: Int)
  case pagination(page: Int, resultCount: Int, seed: String)
}

// MARK: - TargetType

extension RandomUserService {

  var baseURL: URL {
    URL(string: "https://randomuser.me")!
  }

  var path: String {
    switch self {
    case .multipleUsers,
         .pagination:
      return "/api/"
    }
  }

  var method: Method {
    switch self {
    case .multipleUsers,
         .pagination:
      return .get
    }
  }

  var sampleData: Data {
    RandomUserFixture.data
  }

  var task: Task {
    switch self {
    case let .multipleUsers(resultCount):
      return .requestParameters(
        parameters: ["results": resultCount],
        encoding: URLEncoding.default
      )

    case let .pagination(page, resultCount, seed):
      return .requestParameters(
        parameters: [
          "page": page,
          "results": resultCount,
          "seed": seed
        ],
        encoding: URLEncoding.default
      )
    }
  }

  var headers: [String: String]? {
    ["Content-Type": "application/json; charset=utf-8"]
  }
}
