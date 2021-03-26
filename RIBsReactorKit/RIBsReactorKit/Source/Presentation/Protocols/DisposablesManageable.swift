//
//  DisposablesManageable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/31.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxSwift

protocol DisposablesManageable {
  func disposeDisposables()
  func resetDisposables()
}

extension DisposablesManageable where Self: HasCompositeDisposable {
  func disposeDisposables() {
    disposables.dispose()
  }

  func resetDisposables() {
    disposables.dispose()
    disposables = CompositeDisposable()
  }
}
