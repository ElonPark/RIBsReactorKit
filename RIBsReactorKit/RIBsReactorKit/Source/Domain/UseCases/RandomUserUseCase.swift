//
//  RandomUserUseCase.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

// MARK: - RandomUserUseCase

protocol RandomUserUseCase {
  func loadData(isRefresh: Bool, itemCount: Int) -> Observable<Void>
}

// MARK: - RandomUserUseCaseImpl

final class RandomUserUseCaseImpl: RandomUserUseCase {

  // MARK: - Properties

  private let repository: RandomUserRepository
  private let translator: UserModelTranslator
  private let mutableUserModelDataStream: MutableUserModelDataStream

  private let userItemInfoRelay = BehaviorRelay(value: RandomUserItemInfo())
  private var userItemInfoRelayBuilder: PropertyBuilder<RandomUserItemInfo> { userItemInfoRelay.value.builder }

  private var responseInfo: Info? { userItemInfoRelay.value.info }
  private var userByUUID: [String: User] { userItemInfoRelay.value.userByUUID }
  private var isLastItems: Bool { userItemInfoRelay.value.isLastItems }

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
    return randomUsers(isRefresh: isRefresh, itemCount: itemCount)
      .map(\.results)
      .withUnretained(self)
      .do(onNext: { this, results in
        this.setIsLastItems(by: results, itemCount: itemCount)
        if isRefresh {
          this.updateUserModels(by: results)
        } else {
          this.appendUserModels(by: results)
        }
      })
      .map { _ in Void() }
  }

  // MARK: - Private methods

  private func randomUsers(isRefresh: Bool, itemCount: Int) -> Observable<RandomUser> {
    let randomUsers: Single<RandomUser>
    if let info = responseInfo, !isRefresh {
      let page = info.page + 1
      randomUsers = repository.randomUsers(with: page, count: itemCount, seed: info.seed)
    } else {
      randomUsers = repository.randomUsers(with: itemCount)
    }

    return randomUsers
      .asObservable()
      .withUnretained(self)
      .do(onNext: { this, response in
        this.updateResponseInfo(by: response.info)
        this.updateUserByUUID(by: response.results)
      })
      .map { _, response in response }
  }

  private func updateResponseInfo(by responseInfo: Info) {
    userItemInfoRelay.accept(userItemInfoRelayBuilder.info(responseInfo))
  }

  private func updateUserByUUID(by users: [User]) {
    let userByUUID = users.reduce(into: userByUUID) { userDictionary, user in
      userDictionary[user.login.uuid] = user
    }
    userItemInfoRelay.accept(userItemInfoRelayBuilder.userByUUID(userByUUID))
  }

  private func setIsLastItems(by results: [User], itemCount: Int) {
    let isLastItems = results.isEmpty || results.count < itemCount
    userItemInfoRelay.accept(userItemInfoRelayBuilder.isLastItems(isLastItems))
  }

  private func updateUserModels(by results: [User]) {
    let userModels = translator.translateToUserModel(by: results)
    mutableUserModelDataStream.updateUserModels(with: userModels)
  }

  private func appendUserModels(by results: [User]) {
    let userModels = translator.translateToUserModel(by: results)
    mutableUserModelDataStream.appendUserModels(with: userModels)
  }
}
