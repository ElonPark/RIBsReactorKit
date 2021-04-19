//
//  RandomUserUseCase.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - RandomUserUseCase

protocol RandomUserUseCase {
  func loadData(isRefresh: Bool, itemCount: Int) -> Observable<Void>
}

// MARK: - RandomUserUseCaseImpl

final class RandomUserUseCaseImpl: RandomUserUseCase {

  // MARK: - Properties

  private var isLastItems: Bool = false

  private let repository: RandomUserRepository
  private let translator: UserModelTranslator
  private let mutableUserModelDataStream: MutableUserModelDataStream

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
    let randomUsers: Single<RandomUser>
    if let info = repository.info, !isRefresh {
      let page = info.page + 1
      randomUsers = repository.randomUsers(with: page, count: itemCount, seed: info.seed)
    } else {
      randomUsers = repository.randomUsers(with: itemCount)
    }

    return randomUsers
      .asObservable()
      .map(\.results)
      .do(onNext: { [weak self] results in
        self?.setIsLastItems(by: results, itemCount: itemCount)
        if isRefresh {
          self?.updateUserModels(by: results)
        } else {
          self?.appendUserModels(by: results)
        }
      })
      .map { _ in Void() }
  }

  // MARK: - Private methods

  private func setIsLastItems(by results: [User], itemCount: Int) {
    isLastItems = results.isEmpty || results.count < itemCount
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
