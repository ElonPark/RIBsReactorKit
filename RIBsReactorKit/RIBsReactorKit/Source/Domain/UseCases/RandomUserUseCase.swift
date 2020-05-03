//
//  RandomUserUseCase.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/27.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxSwift
import RxCocoa

protocol RandomUserUseCase {
  var isLastItems: Bool { get }
  var translator: UserModelTranslator { get }
  var repository: RandomUserRepository { get }
  var mutableUserModelsStream: MutableUserModelsStream { get }

  func loadData(isRefresh: Bool) -> Observable<Void>
}

final class RandomUserUseCaseImpl: RandomUserUseCase {
  
  // MARK: - Properties
  
  let itemCount: Int = 50
  
  private (set) var isLastItems: Bool = false
  
  let repository: RandomUserRepository
  
  let translator: UserModelTranslator
  
  let mutableUserModelsStream: MutableUserModelsStream
  
  // MARK: - Con(De)structor

  init(
    repository: RandomUserRepository,
    translator: UserModelTranslator,
    mutableUserModelsStream: MutableUserModelsStream
  ) {
    self.repository = repository
    self.translator = translator
    self.mutableUserModelsStream = mutableUserModelsStream
  }
  
  // MARK: - Internal methods
  
  func loadData(isRefresh: Bool) -> Observable<Void> {
    let randomUsers: Single<RandomUser>
    if let info = repository.info, !isRefresh {
      let page = info.page + 1
      randomUsers = repository.randomUsers(with: page, count: itemCount, seed: info.seed)
    } else {
      randomUsers = repository.randomUsers(with: itemCount)
    }
    
    return randomUsers
      .asObservable()
      .map { $0.results }
      .do(onNext: { [weak self] results in
        self?.setIsLastItems(by: results)
        if isRefresh {
          self?.updateUserModels(by: results)
        } else {
          self?.appendUserModels(by: results)
        }
      })
      .map { _ in Void() }
  }
  
  // MARK: - Private methods
  
  private func setIsLastItems(by results: [User]) {
    isLastItems = results.isEmpty || results.count < itemCount
  }
  
  private func updateUserModels(by results: [User]) {
    let userModels = translator.translateToUserModel(by: results)
    mutableUserModelsStream.updateUserModals(with: userModels)
  }
  
  private func appendUserModels(by results: [User]) {
    let userModels = translator.translateToUserModel(by: results)
    mutableUserModelsStream.appendUserModals(with: userModels)
  }
}
