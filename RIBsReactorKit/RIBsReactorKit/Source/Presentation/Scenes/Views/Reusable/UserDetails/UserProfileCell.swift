//
//  UserProfileCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

// MARK: - UserProfileCell

final class UserProfileCell:
  BaseCollectionViewCell,
  HasConfigure,
  SkeletonViewsAnimatable
{

  // MARK: - Constants

  enum UI {
    // - profileBackgroundImageView
    static let profileBackgroundImageViewCornerRadius: CGFloat = 18
    static let profileBackgroundImageViewHeight: CGFloat = 120
    static let profileBackgroundImageTopMargin: CGFloat = 8
    static let profileBackgroundImageLeadingMargin: CGFloat = 8
    static let profileBackgroundImageViewTrailingMargin: CGFloat = 8

    // - profileImageView
    static let profileImageViewSize = CGSize(width: 120, height: 120)
    static let profileImageViewBorderWidth: CGFloat = 5

    // - label
    static let labelMinimumSideMargin: CGFloat = 16

    // - titleWithLastNameLabel
    static let titleWithLastNameLabelTopMargin: CGFloat = 8

    // - firstNameLabel
    static let firstNameLabelTopMargin: CGFloat = 3
    static let firstNameLabelBottomMargin: CGFloat = 8

    enum Font {
      static let titleWithLastNameLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
      static let firstNameLabel = UIFont.systemFont(ofSize: 15)
    }
  }

  // MARK: - Properties

  private(set) var viewModel: UserProfileViewModel?

  // for skeleton view animation
  private let dummyTitleWithLastNameString = String(repeating: " ", count: 60)
  private let dummyFirstNameString = String(repeating: " ", count: 40)

  // MARK: - UI Components

  private let profileBackgroundImageView = BlurEffectImageView().builder
    .blurStyle(.light)
    .backgroundColor(.skeletonDefault)
    .contentMode(.scaleAspectFill)
    .set(\.layer.masksToBounds, to: true)
    .set(\.layer.cornerRadius, to: UI.profileBackgroundImageViewCornerRadius)
    .set(\.layer.maskedCorners, to: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
    .isSkeletonable(true)
    .build()

  private let profileImageView = BaseImageView().builder
    .backgroundColor(.skeletonDefault)
    .contentMode(.scaleAspectFill)
    .set(\.layer.borderWidth, to: UI.profileImageViewBorderWidth)
    .set(\.layer.borderColor, to: UIColor.white.cgColor)
    .set(\.layer.masksToBounds, to: true)
    .set(\.layer.cornerRadius, to: UI.profileImageViewSize.height / 2)
    .isSkeletonable(true)
    .build()

  private lazy var titleWithLastNameLabel = UILabel().builder
    .font(UI.Font.titleWithLastNameLabel)
    .textAlignment(.center)
    .text(dummyTitleWithLastNameString)
    .isSkeletonable(true)
    .build()

  private lazy var firstNameLabel = UILabel().builder
    .font(UI.Font.firstNameLabel)
    .textAlignment(.center)
    .text(dummyFirstNameString)
    .isSkeletonable(true)
    .build()

  var skeletonViews: [UIView] {
    [
      profileBackgroundImageView,
      profileImageView,
      titleWithLastNameLabel,
      firstNameLabel
    ]
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
    initUI()
  }

  // MARK: - Internal methods

  func configure(by viewModel: UserProfileViewModel) {
    self.viewModel = viewModel
    profileBackgroundImageView.kf.setImage(with: viewModel.profileBackgroundImageURL)
    profileImageView.kf.setImage(with: viewModel.profileImageURL)
    titleWithLastNameLabel.text = viewModel.titleWithLastName
    firstNameLabel.text = viewModel.firstName
  }

  // MARK: - Private methods

  private func initUI() {
    profileBackgroundImageView.image = nil
    profileImageView.image = nil
    titleWithLastNameLabel.text = dummyTitleWithLastNameString
    firstNameLabel.text = dummyFirstNameString
  }
}

// MARK: - Layout

extension UserProfileCell {
  private func setupUI() {
    isSkeletonable = true
    skeletonViews.forEach { contentView.addSubview($0) }

    initUI()
  }

  private func layout() {
    profileBackgroundImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(UI.profileBackgroundImageTopMargin)
      $0.leading.equalToSuperview().offset(UI.profileBackgroundImageLeadingMargin)
      $0.trailing.equalToSuperview().offset(-UI.profileBackgroundImageViewTrailingMargin)
      $0.height.equalTo(UI.profileBackgroundImageViewHeight)
    }

    profileImageView.snp.makeConstraints {
      $0.size.equalTo(UI.profileImageViewSize)
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(profileBackgroundImageView.snp.bottom)
    }

    titleWithLastNameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.bottom).offset(UI.titleWithLastNameLabelTopMargin)
      $0.leading.greaterThanOrEqualToSuperview().offset(UI.labelMinimumSideMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.labelMinimumSideMargin)
      $0.centerX.equalToSuperview()
    }

    firstNameLabel.snp.makeConstraints {
      $0.top.equalTo(titleWithLastNameLabel.snp.bottom).offset(UI.firstNameLabelTopMargin)
      $0.bottom.lessThanOrEqualToSuperview().offset(-UI.firstNameLabelBottomMargin)
      $0.leading.greaterThanOrEqualToSuperview().offset(UI.labelMinimumSideMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.labelMinimumSideMargin)
      $0.centerX.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  @available(iOS 13.0, *)
  struct UserProfileCellPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      UIViewPreview {
        UserProfileCell()
      }
      .previewLayout(.fixed(width: 250, height: 320))
      .padding(10)
    }
  }
#endif
