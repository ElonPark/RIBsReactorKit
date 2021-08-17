//
//  HasRefreshStream.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import ReactorKit
import RxSwift

// MARK: - HasRefreshState

protocol HasRefreshState {
  var isRefresh: Bool { get }
}

// MARK: - HasRefreshStream

protocol HasRefreshStream {
  var isRefreshStream: Observable<Bool> { get }
}

extension HasRefreshStream where Self: Reactor, Self.State: HasRefreshState {
  var isRefreshStream: Observable<Bool> {
    state.map(\.isRefresh)
  }
}

extension HasRefreshStream where Self: HasViewModel, Self.ViewModel: HasRefreshState {
  var isRefreshStream: Observable<Bool> {
    viewModel.map(\.isRefresh)
  }
}
