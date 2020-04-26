//
//  RandomUserService.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Moya

enum RandomUserService {
  case multipleUsers(resultCount: Int)
  case pagination(page: Int, resultCount: Int, seed: String)
}

extension RandomUserService: TargetType {
  
  var baseURL: URL {
    return URL(string: "https://randomuser.me")!
  }
  
  var path: String {
    switch self {
    case .multipleUsers, .pagination:
      return "/api/"
    }
  }
  
  var method: Method {
    switch self {
    case .multipleUsers, .pagination:
      return .get
    }
  }
  
  var sampleData: Data {
    return RandomUserFixture.data
  }
  
  var task: Task {
    switch self {
    case .multipleUsers(let resultCount):
      return .requestParameters(
        parameters: ["results": resultCount],
        encoding: URLEncoding.default
      )
      
    case .pagination(let page, let resultCount, let seed):
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
  
  var headers: [String : String]? {
    return ["Content-Type": "application/json; charset=utf-8"]
  }
}
