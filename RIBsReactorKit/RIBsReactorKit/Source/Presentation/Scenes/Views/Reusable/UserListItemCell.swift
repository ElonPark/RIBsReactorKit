//
//  UserListItemCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/06.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import Kingfisher
import SkeletonView
import SnapKit

// MARK: - UserListItemCell

final class UserListItemCell:
  BaseTableViewCell,
  HasConfigure,
  SkeletonViewsAnimatable
{

  // MARK: - Constants

  private enum UI {
    // - profileImageView
    static let profileImageViewTopMargin: CGFloat = 8
    static let profileImageViewBottomMargin: CGFloat = 8
    static let profileImageViewLeadingMargin: CGFloat = 8
    static let profileImageViewSize = CGSize(width: 50, height: 50)

    // - nameLabel
    static let nameLabelTopMargin: CGFloat = 10
    static let nameLabelLeadingMargin: CGFloat = 8
    static let nameLabelTrailingMargin: CGFloat = 8

    // - locationLabel
    static let locationLabelTopMargin: CGFloat = 5
    static let locationLabelBottomMargin: CGFloat = 8
    static let locationLabelTrailingMargin: CGFloat = 8

    // - skeleton
    static let linesCornerRadius: Int = 10
  }

  // MARK: - Properties

  private(set) var viewModel: UserListItemViewModel?

  // for skeleton view animation
  private let dummyNameString = String(repeating: " ", count: 60)
  private let dummyLocationString = String(repeating: " ", count: 40)

  // MARK: - UI Components

  private let profileImageView = BaseImageView().builder
    .contentMode(.scaleAspectFit)
    .backgroundColor(.skeletonDefault)
    .set(\.layer.masksToBounds, to: true)
    .set(\.layer.cornerRadius, to: UI.profileImageViewSize.height / 2)
    .isSkeletonable(true)
    .build()

  private lazy var nameLabel = UILabel().builder
    .font(.systemFont(ofSize: 17, weight: .medium))
    .text(dummyNameString)
    .isSkeletonable(true)
    .linesCornerRadius(UI.linesCornerRadius)
    .build()

  private lazy var locationLabel = UILabel().builder
    .font(.systemFont(ofSize: 15, weight: .regular))
    .text(dummyLocationString)
    .isSkeletonable(true)
    .linesCornerRadius(UI.linesCornerRadius)
    .build()

  var skeletonViews: [UIView] {
    [profileImageView, nameLabel, locationLabel]
  }

  // MARK: - Inheritance

  override func initialize() {
    super.initialize()
    setUpUI()
    showGradientSkeleton()
  }

  override func setupConstraints() {
    super.setupConstraints()
    layout()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    profileImageView.kf.cancelDownloadTask()
    initUI()
  }

  // MARK: - Internal methods

  func configure(by viewModel: UserListItemViewModel) {
    self.viewModel = viewModel
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    nameLabel.text = viewModel.titleWithFullName
    locationLabel.text = viewModel.location
    hideSkeleton()
  }

  // MARK: - Private methods

  private func initUI() {
    profileImageView.image = nil
    nameLabel.text = dummyNameString
    locationLabel.text = dummyLocationString
  }
}

// MARK: - Layout

extension UserListItemCell {
  private func setUpUI() {
    selectionStyle = .none
    isSkeletonable = true
    skeletonViews.forEach { contentView.addSubview($0) }

    initUI()
  }

  private func layout() {
    profileImageView.snp.makeConstraints {
      $0.size.equalTo(UI.profileImageViewSize)
      $0.top.greaterThanOrEqualToSuperview().offset(UI.profileImageViewTopMargin)
      $0.bottom.lessThanOrEqualToSuperview().offset(-UI.profileImageViewBottomMargin)
      $0.leading.equalToSuperview().offset(UI.profileImageViewLeadingMargin)
      $0.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.top)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(UI.nameLabelLeadingMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.nameLabelTrailingMargin)
    }

    locationLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(UI.locationLabelTopMargin)
      $0.bottom.lessThanOrEqualTo(profileImageView.snp.bottom)
      $0.leading.equalTo(nameLabel.snp.leading)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.locationLabelTrailingMargin)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  struct UserListItemCellPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      UIViewPreview {
        UserListItemCell()
      }
      .previewLayout(.fixed(width: 320, height: 100))
      .padding(10)
    }
  }
#endif
