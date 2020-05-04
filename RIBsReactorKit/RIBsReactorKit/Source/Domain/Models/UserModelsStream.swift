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
  var userModals: Observable<[UserModel]> { get }
}

protocol MutableUserModelsStream: UserModelsStream {
  func updateUserModals(with userModals: [UserModel])
  func appendUserModals(with userModals: [UserModel])
}

final class UserModelsStreamImpl: MutableUserModelsStream {
  
  // MARK: - Properties

  var userModals: Observable<[UserModel]> {
    return userModalsRelay
    .asObservable()
  }
  
  private let userModalsRelay = BehaviorRelay<[UserModel]>(value: [])
  
  // MARK: - Internal methods

  func updateUserModals(with userModals: [UserModel]) {
    userModalsRelay.accept(userModals)
  }
  
  func appendUserModals(with userModals: [UserModel]) {
    var newUserModals: [UserModel] {
      var modals = userModalsRelay.value
      modals.append(contentsOf: userModals)
      return modals
    }
    
    userModalsRelay.accept(newUserModals)
  }
}
