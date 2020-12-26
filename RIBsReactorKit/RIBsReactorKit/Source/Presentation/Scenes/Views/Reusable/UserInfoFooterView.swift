//
//  UserInfoFooterView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

final class UserInfoFooterView:
  BaseCollectionReusableView,
  HasElementKind
{
  
  private enum UI {
    // - separatorLineView
    static let separatorLineViewHeight: CGFloat = 0.5
    
    enum Color {
      static let separatorLine: UIColor = .lightGray
    }
  }
  
  // MARK: - Properties
  
  static var elementKind: String = UICollectionView.elementKindSectionFooter
  
    // MARK: - UI Components
  
  private let separatorLineView = UIView().then {
    $0.backgroundColor = UI.Color.separatorLine
  }
  
  // MARK: - Inheritance
  
  override func initialize() {
    super.initialize()
    setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    layout()
  }
}

// MARK: - Layout
extension UserInfoFooterView {
  private func setupUI() {
    self.addSubview(separatorLineView)
  }
  
  private func layout() {
    separatorLineView.snp.makeConstraints {
      $0.height.equalTo(UI.separatorLineViewHeight)
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
    }
  }
}
