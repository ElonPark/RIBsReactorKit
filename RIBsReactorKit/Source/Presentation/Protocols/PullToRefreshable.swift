//
//  PullToRefreshable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/24.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxRelay
import RxSwift

// MARK: - PullToRefreshable

protocol PullToRefreshable {
  var refreshControl: UIRefreshControl { get }
  var refreshEvent: PublishRelay<Void> { get }
}

extension PullToRefreshable where Self: HasDisposeBag {
  func bindRefreshControlEvent() {
    refreshControl.rx.controlEvent(.valueChanged)
      .asObservable()
      .bind(to: refreshEvent)
      .disposed(by: disposeBag)
  }

  func endRefreshing() {
    refreshControl.endRefreshing()
  }
}

extension PullToRefreshable where Self: HasTableView {
  func setRefreshControl() {
    tableView.refreshControl = refreshControl
  }
}

extension PullToRefreshable where Self: HasCollectionView {
  func setRefreshControl() {
    collectionView.refreshControl = refreshControl
  }
}
