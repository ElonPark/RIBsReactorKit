//
//  CloseButtonBindable.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import RxSwift

// MARK: - CloseButtonBindable

protocol CloseButtonBindable {
  func bindCloseButtonTapAction()
}

extension CloseButtonBindable where Self: HasCloseButtonHeaderView & HasDetachAction & HasDisposeBag {
  func bindCloseButtonTapAction() {
    headerView.closeButton.rx.tap
      .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
      .bind(to: detachAction)
      .disposed(by: disposeBag)
  }
}
