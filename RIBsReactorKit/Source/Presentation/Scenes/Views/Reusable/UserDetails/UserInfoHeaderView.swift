//
//  UserInfoHeaderView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/18.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

// MARK: - UserInfoHeaderView

final class UserInfoHeaderView:
  BaseCollectionReusableView,
  HasElementKind,
  HasConfigure,
  SkeletonViewsAnimatable
{

  // MARK: - Constants

  private enum UI {
    // - titleLabel
    static let titleLabelTopMargin: CGFloat = 0
    static let titleLabelBottomMargin: CGFloat = 8
    static let titleLabelLeadingMargin: CGFloat = 16
    static let titleLabelTrailingMargin: CGFloat = 16

    // - skeleton
    static let linesCornerRadius: Int = 10

    enum Font {
      static let titleLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
  }

  // MARK: - Properties

  static var elementKind: String = UICollectionView.elementKindSectionHeader

  // MARK: - UI Components

  private lazy var titleLabel = BaseLabel().builder
    .font(UI.Font.titleLabel)
    .isSkeletonable(true)
    .linesCornerRadius(UI.linesCornerRadius)
    .build()

  var skeletonViews: [UIView] {
    [titleLabel]
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

  override func prepareForReuse() {
    super.prepareForReuse()
    self.initUI()
  }

  // MARK: - Internal methods

  func configure(by viewModel: UserInfoSectionHeaderViewModel) {
    self.titleLabel.text = viewModel.title
  }

  // MARK: - Private methods

  private func initUI() {
    self.titleLabel.text = ""
  }
}

// MARK: - Layout

extension UserInfoHeaderView {
  private func setupUI() {
    isSkeletonable = true
    self.skeletonViews.forEach { self.addSubview($0) }

    self.initUI()
  }

  private func layout() {
    self.titleLabel.snp.makeConstraints {
      $0.top.greaterThanOrEqualToSuperview().offset(UI.titleLabelTopMargin)
      $0.bottom.equalToSuperview().offset(-UI.titleLabelBottomMargin)
      $0.leading.equalToSuperview().offset(UI.titleLabelLeadingMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.titleLabelTrailingMargin)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  struct UserInformationSectionHeaderViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      UIViewPreview {
        UserInfoHeaderView().builder
          .with {
            $0.configure(by: UserInfoSectionHeaderViewModel(title: "test"))
          }
          .build()
      }
      .previewLayout(.fixed(width: 320, height: 50))
      .padding(10)
    }
  }
#endif
