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

extension PullToRefreshable where Self: HasTableView & HasDisposeBag {
  func setRefreshControl() {
    tableView.refreshControl = refreshControl
  }

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
