//
//  UserModelStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/20.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxSwift
import RxRelay

protocol UserModelStream {
  var userModel: Observable<UserModel> { get }
}

protocol MutableUserModelStream: UserModelStream {
  func updateUserModel(by userModel: UserModel)
}

final class UserModelStreamImpl: MutableUserModelStream {
  
  // MARK: - Properties

  lazy var userModel: Observable<UserModel> = userModalRelay.asObservable().compactMap { $0 }
  private let userModalRelay = BehaviorRelay<UserModel?>(value: nil)
  
  // MARK: - Internal methods

  func updateUserModel(by userModel: UserModel) {
    userModalRelay.accept(userModel)
  }
}
