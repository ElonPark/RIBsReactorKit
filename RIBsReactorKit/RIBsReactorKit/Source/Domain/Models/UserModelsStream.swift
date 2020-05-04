//
//  UserModelsStream.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import MapKit

import RxSwift
import RxRelay

struct UserModel {
  let gender: String
  let name: Name
  let email: String
  let login: Login
  let dob: Dob
  let phone: String
  let cell: String
  let id: ID
  let nat: String
  let location: Location
  let coordinates: CLLocationCoordinate2D?
  let largeImageURL: URL?
  let mediumImageURL: URL?
  let thumbnailImageURL: URL?
}

extension UserModel: Equatable {
  static func == (lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.login.uuid == rhs.login.uuid
  }
}

protocol UserModelsStream {
  var userModels: Observable<[UserModel]> { get }
}

protocol MutableUserModelsStream: UserModelsStream {
  func updateUserModels(with userModels: [UserModel])
  func appendUserModels(with userModels: [UserModel])
}

final class UserModelsStreamImpl: MutableUserModelsStream {
  
  // MARK: - Properties

  var userModels: Observable<[UserModel]> {
    return userModalsRelay
    .asObservable()
  }
  
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
