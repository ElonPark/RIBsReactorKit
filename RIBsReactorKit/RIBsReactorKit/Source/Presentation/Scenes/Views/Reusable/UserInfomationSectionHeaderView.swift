//
//  UserInfomationSectionHeaderView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/18.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

class UserInfomationSectionHeaderView:
  BaseCollectionReusableView,
  HasViewModel,
  SkeletonAnimatable
{
 
  // MARK: - Constants
  
  private enum UI {
    // - titleLabel
    static let titleLabelTopMargin: CGFloat = 0
    static let titleLabelBottomMargin: CGFloat = 0
    static let titleLabelLeadingMargin: CGFloat = 8
    static let titleLabelTrailingMargin: CGFloat = 8
    
    // - skeleton
    static let linesCornerRadius: Int = 10
    
    enum Font {
      static let titleLabel: UIFont = .systemFont(ofSize: 24, weight: .bold)
    }
  }
  
  // MARK: - Properties
  
  var viewModel: UserInfomationSectionHeaderViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      hideSkeletonAnimation()
      titleLabel.text = viewModel.title
    }
  }
  
  // for skeleton view animation
  private let dummyTitleString = String(repeating: " ", count: 30)
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.font = UI.Font.titleLabel
    $0.textColor = .black
    $0.isSkeletonable = true
    $0.linesCornerRadius = UI.linesCornerRadius
  }
  
  private(set) lazy var views: [UIView] = [
    titleLabel
  ]

  // MARK: - Inheritance
  
  override func initialize() {
    super.initialize()
    setupUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    layout()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    initUI()
  }
  
  // MARK: - Private methods
  
  private func initUI() {
    titleLabel.text = dummyTitleString
  }
}

// MARK: - Layout
extension UserInfomationSectionHeaderView {
  private func setupUI() {
    self.isSkeletonable = true
    views.forEach { self.addSubview($0) }
    
    initUI()
    showSkeletonAnimation()
  }
  
  private func layout() {
    titleLabel.snp.makeConstraints {
      $0.top.greaterThanOrEqualToSuperview().offset(UI.titleLabelTopMargin)
      $0.bottom.equalToSuperview().offset(-UI.titleLabelBottomMargin)
      $0.leading.equalToSuperview().offset(UI.titleLabelLeadingMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.titleLabelTrailingMargin)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct UserInfomationSectionHeaderViewPreview: PreviewProvider {
  static var previews: some SwiftUI.View {
    UIViewPreview {
      UserInfomationSectionHeaderView().then {
        $0.viewModel = UserInfomationSectionHeaderViewModel(title: "test")
      }
    }
    .previewLayout(.fixed(width: 320, height: 50))
    .padding(10)
  }
}
#endif
