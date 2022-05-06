//
//  CloseButtonHeaderView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2021/07/20.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import SnapKit

final class CloseButtonHeaderView: BaseView {

  // MARK: - Constants

  private enum UI {
    static let buttonHeight: CGFloat = 30
    static var cornerRadius: CGFloat { buttonHeight / 2 }
  }

  let closeButton = UIButton().builder
    .contentEdgeInsets(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
    .backgroundColor(.black)
    .set(\.layer.cornerRadius, to: UI.cornerRadius)
    .with {
      $0.setTitle(Strings.Common.close, for: .normal)
    }
    .build()

  override func initialize() {
    super.initialize()
    backgroundColor = Asset.Colors.backgroundColor.color
    addSubview(closeButton)
  }

  override func setupConstraints() {
    super.setupConstraints()
    makeCloseButtonConstraints()
  }

  private func makeCloseButtonConstraints() {
    let safeArea = safeAreaLayoutGuide.snp

    closeButton.snp.makeConstraints {
      $0.height.equalTo(UI.buttonHeight)
      $0.centerY.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.leading.greaterThanOrEqualTo(safeArea.leading).offset(15)
      $0.trailing.equalTo(safeArea.trailing).offset(-15)
    }
  }
}
