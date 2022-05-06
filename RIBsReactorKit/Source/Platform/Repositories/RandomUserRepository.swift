//
//  RandomUserRepository.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

import RxSwift

// MARK: - RandomUserRepository

protocol RandomUserRepository {
  func randomUsers(withResultCount resultCount: Int) -> Single<RandomUser>
  func randomUsers(withPageNumber page: Int, count: Int, seed: String) -> Single<RandomUser>
}

// MARK: - RandomUserRepositoryImpl

final class RandomUserRepositoryImpl: NetworkRepository<RandomUserAPI>, RandomUserRepository {

  // MARK: - Properties

  private let jsonDecoder = JSONDecoder().builder
    .dateDecodingStrategy(.iso8601withFractionalSeconds)
    .build()

  // MARK: - Internal methods

  func randomUsers(withResultCount resultCount: Int) -> Single<RandomUser> {
    return provider.request(.multipleUsers(resultCount: resultCount))
      .map(RandomUser.self, using: jsonDecoder, failsOnEmptyData: false)
  }

  func randomUsers(withPageNumber page: Int, count: Int, seed: String) -> Single<RandomUser> {
    provider.request(.pagination(page: page, resultCount: count, seed: seed))
      .map(RandomUser.self, using: jsonDecoder, failsOnEmptyData: false)
  }
}
