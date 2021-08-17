//
//  SelectedUserModelStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/12/20.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

// MARK: - SelectedUserModelStream

protocol SelectedUserModelStream {
  var userModel: Observable<UserModel> { get }
}

// MARK: - MutableSelectedUserModelStream

protocol MutableSelectedUserModelStream: SelectedUserModelStream {
  func updateSelectedUserModel(by userModel: UserModel)
}

// MARK: - SelectedUserModelStreamImpl

final class SelectedUserModelStreamImpl: MutableSelectedUserModelStream {

  // MARK: - Properties

  var userModel: Observable<UserModel> { userModalRelay.asObservable().compactMap { $0 } }
  private let userModalRelay = BehaviorRelay<UserModel?>(value: nil)

  // MARK: - Internal methods

  func updateSelectedUserModel(by userModel: UserModel) {
    userModalRelay.accept(userModel)
  }
}
