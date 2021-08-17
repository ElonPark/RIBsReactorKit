//
//  NetworkRepository.swift
//  RIBsReactorKit
//
//  Created by haskell on 2021/07/26.
//  Copyright © 2021 Elon. All rights reserved.
//

import Moya

class NetworkRepository<Service: TargetType> {
  let provider: Networking<Service>

  init(networkingProvider: Networking<Service>) {
    self.provider = networkingProvider
  }
}
