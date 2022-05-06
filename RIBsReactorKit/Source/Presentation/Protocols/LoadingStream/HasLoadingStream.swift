//
//  HasLoadingPropertyStream.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import ReactorKit
import RxSwift

// MARK: - HasLoadingState

protocol HasLoadingState {
  var isLoading: Bool { get }
}

// MARK: - HasLoadingStream

protocol HasLoadingStream {
  var isLoadingStream: Observable<Bool> { get }
}

extension HasLoadingStream where Self: Reactor, Self.State: HasLoadingState {
  var isLoadingStream: Observable<Bool> {
    state.map(\.isLoading)
  }
}

extension HasLoadingStream where Self: HasViewModel, Self.ViewModel: HasLoadingState {
  var isLoadingStream: Observable<Bool> {
    viewModel.map(\.isLoading)
  }
}
