//
//  HasDetachAction.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import RxRelay

protocol HasDetachAction {
  var detachAction: PublishRelay<Void> { get }
}
