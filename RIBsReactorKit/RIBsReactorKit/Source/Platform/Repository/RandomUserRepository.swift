//
//  RandomUserRepository.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/26.
//  Copyright © 2020 Elon. All rights reserved.
//

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
  
  // MARK: - Con(De)structor

  init(service: Networking<RandomUserService>) {
    self.service = service
  }
  
  // MARK: - Internal methods

  func randomUsers(with resultCount: Int) -> Single<RandomUser> {
    return service.request(.multipleUsers(resultCount: resultCount))
      .map(RandomUser.self)
      .do(onSuccess: { [weak self] result in
        guard let this = self else { return }
        this.info = result.info
        this.userByUUID = result.results.reduce(into: this.userByUUID) { userDictionary, user in
          userDictionary[user.login.uuid] = user
        }
      })
  }
  
  func randomUsers(with page: Int, count: Int, seed: String) -> Single<RandomUser> {
    return service.request(.pagination(page: page, resultCount: count, seed: seed))
      .map(RandomUser.self)
      .do(onSuccess: { [weak self] result in
        guard let this = self else { return }
        this.info = result.info
        this.userByUUID = result.results.reduce(into: this.userByUUID) { userDictionary, user in
          userDictionary[user.login.uuid] = user
        }
      })
  }
}
