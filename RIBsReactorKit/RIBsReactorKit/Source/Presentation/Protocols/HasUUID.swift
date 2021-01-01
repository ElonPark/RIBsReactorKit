//
//  HasUUID.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/01/01.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

protocol HasUUID {
  var uuid: String { get }
}

extension HasUUID where Self: HasUserModel {
  var uuid: String {
    userModel.login.uuid
  }
}
