//
//  RandomUserRepositoryService.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

// MARK: - RandomUserRepositoryService

protocol RandomUserRepositoryService {
  func loadData(isRefresh: Bool, itemCount: Int) -> Observable<Void>
}

// MARK: - RandomUserRepositoryServiceImpl

final class RandomUserRepositoryServiceImpl: RandomUserRepositoryService {

  // MARK: - Properties

  private let repository: RandomUserRepository
  private let translator: UserModelTranslator
  private let mutableUserModelDataStream: MutableUserModelDataStream

  private let userItemInfoRelay = BehaviorRelay(value: RandomUserItemInfo())
  private var userItemInfoRelayBuilder: PropertyBuilder<RandomUserItemInfo> { self.userItemInfoRelay.value.builder }

  private var responseInfo: Info? { self.userItemInfoRelay.value.info }
  private var userByUUID: [String: User] { self.userItemInfoRelay.value.userByUUID }
  private var isLastItems: Bool { self.userItemInfoRelay.value.isLastItems }

  // MARK: - Initialization & Deinitialization

  init(
    repository: RandomUserRepository,
    translator: UserModelTranslator,
    mutableUserModelsStream: MutableUserModelDataStream
  ) {
    self.repository = repository
    self.translator = translator
    self.mutableUserModelDataStream = mutableUserModelsStream
  }

  // MARK: - Internal methods

  func loadData(isRefresh: Bool, itemCount: Int) -> Observable<Void> {
    return self.randomUsers(isRefresh: isRefresh, itemCount: itemCount)
      .map(\.results)
      .withUnretained(self)
      .map { this, results in
        this.setIsLastItems(by: results, itemCount: itemCount)
        if isRefresh {
          this.updateUserModels(by: results)
        } else {
          this.appendUserModels(by: results)
        }

        return Void()
      }
  }

  // MARK: - Private methods

  private func randomUsers(isRefresh: Bool, itemCount: Int) -> Observable<RandomUser> {
    let randomUsers: Single<RandomUser>
    if let info = responseInfo, !isRefresh {
      let page = info.page + 1
      randomUsers = self.repository.randomUsers(withPageNumber: page, count: itemCount, seed: info.seed)
    } else {
      randomUsers = self.repository.randomUsers(withResultCount: itemCount)
    }

    return randomUsers
      .asObservable()
      .withUnretained(self)
      .map { this, response in
        this.updateResponseInfo(by: response.info)
        this.updateUserByUUID(by: response.results)

        return response
      }
  }

  private func updateResponseInfo(by responseInfo: Info) {
    self.userItemInfoRelay.accept(self.userItemInfoRelayBuilder.info(responseInfo))
  }

  private func updateUserByUUID(by users: [User]) {
    let userByUUID = users.reduce(into: userByUUID) { userDictionary, user in
      userDictionary[user.login.uuid] = user
    }
    self.userItemInfoRelay.accept(self.userItemInfoRelayBuilder.userByUUID(userByUUID))
  }

  private func setIsLastItems(by results: [User], itemCount: Int) {
    let isLastItems = results.isEmpty || results.count < itemCount
    self.userItemInfoRelay.accept(self.userItemInfoRelayBuilder.isLastItems(isLastItems))
  }

  private func updateUserModels(by results: [User]) {
    let userModels = self.translator.translateToUserModel(by: results)
    self.mutableUserModelDataStream.updateUserModels(with: userModels)
  }

  private func appendUserModels(by results: [User]) {
    let userModels = self.translator.translateToUserModel(by: results)
    self.mutableUserModelDataStream.appendUserModels(with: userModels)
  }
}
