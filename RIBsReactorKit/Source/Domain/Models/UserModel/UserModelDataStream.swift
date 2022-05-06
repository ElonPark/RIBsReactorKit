//
//  UserModelDataStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxRelay
import RxSwift

// MARK: - UserModelData

struct UserModelData: Equatable {
  let models: [UserModel]
  let modelByUUID: [String: UserModel]

  init(models: [UserModel] = [], modelByUUID: [String: UserModel] = [:]) {
    self.models = models
    self.modelByUUID = modelByUUID
  }
}

// MARK: - UserModelDataStream

protocol UserModelDataStream {
  var userModels: Observable<[UserModel]> { get }

  func userModel(byUUID uuid: String) -> UserModel?
}

// MARK: - MutableUserModelDataStream

protocol MutableUserModelDataStream: UserModelDataStream {
  func updateUserModels(with userModels: [UserModel])
  func appendUserModels(with userModels: [UserModel])
}

// MARK: - UserModelDataStreamImpl

final class UserModelDataStreamImpl: MutableUserModelDataStream {

  // MARK: - Properties

  var userModels: Observable<[UserModel]> { userModelDataRelay.asObservable().map(\.models) }
  private let userModelDataRelay = BehaviorRelay<UserModelData>(value: UserModelData())

  // MARK: - Internal methods

  func userModel(byUUID uuid: String) -> UserModel? {
    return userModelDataRelay.value.modelByUUID[uuid]
  }

  func updateUserModels(with userModels: [UserModel]) {
    let userModelByUUID = userModels.reduce(into: [String: UserModel]()) { $0[$1.uuid] = $1 }
    let data = UserModelData(models: userModels, modelByUUID: userModelByUUID)
    userModelDataRelay.accept(data)
  }

  func appendUserModels(with userModels: [UserModel]) {
    var newUserModals: [UserModel] {
      var modals = userModelDataRelay.value.models
      modals.append(contentsOf: userModels)
      return modals
    }

    var newUserModelByUUID: [String: UserModel] {
      var modelByUUID = userModelDataRelay.value.modelByUUID
      modelByUUID = userModels.reduce(into: modelByUUID) { $0[$1.uuid] = $1 }
      return modelByUUID
    }

    let data = UserModelData(models: newUserModals, modelByUUID: newUserModelByUUID)
    userModelDataRelay.accept(data)
  }
}
