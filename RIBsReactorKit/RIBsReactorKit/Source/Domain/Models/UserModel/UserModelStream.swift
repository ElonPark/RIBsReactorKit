//
//  UserModelStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/20.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

// MARK: - UserModelStream

protocol UserModelStream {
  var userModel: Observable<UserModel> { get }
}

// MARK: - MutableUserModelStream

protocol MutableUserModelStream: UserModelStream {
  func updateUserModel(by userModel: UserModel)
}

// MARK: - UserModelStreamImpl

final class UserModelStreamImpl: MutableUserModelStream {

  // MARK: - Properties

  lazy var userModel: Observable<UserModel> = userModalRelay.asObservable().compactMap { $0 }
  private let userModalRelay = BehaviorRelay<UserModel?>(value: nil)

  // MARK: - Internal methods

  func updateUserModel(by userModel: UserModel) {
    userModalRelay.accept(userModel)
  }
}
