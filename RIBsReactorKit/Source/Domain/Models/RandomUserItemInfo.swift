//
//  RandomUserItemInfo.swift
//  RIBsReactorKit
//
//  Created by haskell on 2021/07/26.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

struct RandomUserItemInfo: PropertyBuilderCompatible {
  var info: Info?
  var userByUUID = [String: User]()
  var isLastItems: Bool = false
}
