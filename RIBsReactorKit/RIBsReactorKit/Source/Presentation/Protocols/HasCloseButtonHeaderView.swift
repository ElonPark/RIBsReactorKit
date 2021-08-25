//
//  HasCloseButtonHeaderView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

// MARK: - HasCloseButtonHeaderView

protocol HasCloseButtonHeaderView {
  var needHeaderView: Bool { get }
  var headerView: CloseButtonHeaderView { get }
}

extension HasCloseButtonHeaderView where Self: UIViewController {
  var needHeaderView: Bool {
    navigationController == nil
  }

  func addHeaderViewIfNeeded(to view: UIView) {
    guard needHeaderView else { return }
    view.addSubview(headerView)
  }

  func makeHeaderViewConstraintsIfNeeded() {
    guard needHeaderView else { return }
    headerView.snp.makeConstraints {
      $0.height.equalTo(52)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
    }
  }
}
