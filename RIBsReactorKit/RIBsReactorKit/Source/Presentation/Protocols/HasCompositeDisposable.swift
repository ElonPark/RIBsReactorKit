//
//  HasCompositeDisposable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/31.
//  Copyright © 2020 Elon. All rights reserved.
//

import RxSwift

protocol HasCompositeDisposable: class {
  var disposables: CompositeDisposable { get set }
}
