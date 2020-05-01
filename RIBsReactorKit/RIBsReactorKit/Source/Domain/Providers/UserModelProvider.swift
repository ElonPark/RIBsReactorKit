//
//  UserModelProvider.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/02.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation

protocol UserModelProvider {
  func makeUserModel(by result: [User]) -> [UserModel]
}

final class UserModelProviderImpl {
  
  func makeUserModel(by result: [User]) -> [UserModel] {
    // TODO: - 구현 2020-05-02 01:29:35
    return result.map { _ in
     UserModel()
    }
  }
}
