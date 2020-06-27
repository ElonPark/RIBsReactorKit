//
//  DisposableExtensions.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/31.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxSwift

extension Disposable {
  
  /// Adds self to `CompositeDisposable`
  ///
  /// - parameter disposables: `CompositeDisposable` to add self to.
  func disposed(by disposables: CompositeDisposable) {
    _ = disposables.insert(self)
  }
}
