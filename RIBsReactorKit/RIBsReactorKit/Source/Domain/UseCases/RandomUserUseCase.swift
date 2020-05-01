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
  var requestItemCount: Int { get }
  var isLastItems: Bool { get }
  var provider: UserModelProvider { get }
  var repository: RandomUserRepository { get }
  var userModels: BehaviorRelay<[UserModel]> { get }

  func loadData(isRefresh: Bool) -> Observable<Void>
}

final class RandomUserUseCaseImpl: RandomUserUseCase {
  
  // MARK: - Properties
  
  let requestItemCount: Int
  
  private (set) var isLastItems: Bool = false
  
  let repository: RandomUserRepository
  
  let provider: UserModelProvider
  
  let userModels: BehaviorRelay<[UserModel]> = .init(value: [])
  
  // MARK: - Con(De)structor

  init(requestItemCount: Int, repository: RandomUserRepository, provider: UserModelProvider) {
    self.requestItemCount = requestItemCount
    self.repository = repository
    self.provider = provider
  }
  
  // MARK: - Internal methods
  
  func loadData(isRefresh: Bool) -> Observable<Void> {
    let randomUsers: Single<RandomUser>
    if let info = repository.info, !isRefresh {
      let page = info.page + 1
      randomUsers = repository.randomUsers(with: page, count: requestItemCount, seed: info.seed)
    } else {
      randomUsers = repository.randomUsers(with: requestItemCount)
    }
    
    return randomUsers
      .asObservable()
      .map { $0.results }
      .do(onNext: { [weak self] results in
        self?.setIsLastItems(by: results)
        self?.updateUserModels(by: results)
      })
      .map { _ in Void() }
  }
  
  // MARK: - Private methods
  
  private func setIsLastItems(by results: [User]) {
    isLastItems = results.isEmpty || results.count < requestItemCount
  }
  
  private func updateUserModels(by results: [User]) {
    var models = userModels.value
    models.append(contentsOf: provider.makeUserModel(by: results))
    userModels.accept(models)
  }
}
