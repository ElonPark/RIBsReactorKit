//
//  RandomUserRepository.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

import RxSwift

protocol RandomUserRepository {
  var info: Info? { get }
  var userByUUID: [String: User] { get }

  func randomUsers(with resultCount: Int) -> Single<RandomUser>
  func randomUsers(with page: Int, count: Int, seed: String) -> Single<RandomUser>
}

final class RandomUserRepositoryImpl: RandomUserRepository {

  // MARK: - Properties

  private(set) var info: Info?
  private(set) var userByUUID = [String: User]()
  private let service: Networking<RandomUserService>

  private lazy var jsonDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
    return decoder
  }()

  // MARK: - Initialization & Deinitialization

  init(service: Networking<RandomUserService>) {
    self.service = service
  }

  // MARK: - Internal methods

  func randomUsers(with resultCount: Int) -> Single<RandomUser> {
    service.request(.multipleUsers(resultCount: resultCount))
      .map(RandomUser.self, using: jsonDecoder, failsOnEmptyData: false)
      .do(onSuccess: { [weak self] response in
        guard let this = self else { return }
        this.info = response.info
        this.updateUserByUUID(by: response.results)
      })
  }

  func randomUsers(with page: Int, count: Int, seed: String) -> Single<RandomUser> {
    service.request(.pagination(page: page, resultCount: count, seed: seed))
      .map(RandomUser.self, using: jsonDecoder, failsOnEmptyData: false)
      .do(onSuccess: { [weak self] response in
        guard let this = self else { return }
        this.info = response.info
        this.updateUserByUUID(by: response.results)
      })
  }

  // MARK: - Private methods

  private func updateUserByUUID(by users: [User]) {
    userByUUID = users.reduce(into: userByUUID) { userDictionary, user in
      userDictionary[user.login.uuid] = user
    }
  }
}
