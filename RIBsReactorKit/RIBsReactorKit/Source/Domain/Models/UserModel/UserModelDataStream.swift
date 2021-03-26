//
//  UserModelDataStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

protocol UserModelDataStream {
  var userModels: Observable<[UserModel]> { get }
}

protocol MutableUserModelDataStream: UserModelDataStream {
  func updateUserModels(with userModels: [UserModel])
  func appendUserModels(with userModels: [UserModel])
}

final class UserModelDataStreamImpl: MutableUserModelDataStream {

  // MARK: - Properties

  lazy var userModels: Observable<[UserModel]> = userModalsRelay.asObservable()
  private let userModalsRelay = BehaviorRelay<[UserModel]>(value: [])

  // MARK: - Internal methods

  func updateUserModels(with userModels: [UserModel]) {
    userModalsRelay.accept(userModels)
  }

  func appendUserModels(with userModels: [UserModel]) {
    var newUserModals: [UserModel] {
      var modals = userModalsRelay.value
      modals.append(contentsOf: userModels)
      return modals
    }

    userModalsRelay.accept(newUserModals)
  }
}
