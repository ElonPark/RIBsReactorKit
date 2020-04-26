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
  var userModels: BehaviorRelay<[UserModel]> { get }
  func loadData() -> Observable<Void>
}

final class RandomUserUseCaseImpl: RandomUserUseCase {
  
  // MARK: - Properties
  
  let userModels: BehaviorRelay<[UserModel]> = .init(value: [])
  
  // MARK: - Internal methods
  
  func loadData() -> Observable<Void> {
    // - TODO: 구현 2020-04-27 01:40:07
    return .just(Void())
  }
}
