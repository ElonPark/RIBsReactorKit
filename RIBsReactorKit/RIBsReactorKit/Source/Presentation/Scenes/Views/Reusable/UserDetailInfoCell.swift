//
//  UserDetailInfoCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/09/13.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

// MARK: - UserDetailInfoCell

final class UserDetailInfoCell:
  BaseCollectionViewCell,
  HasViewModel,
  HasConfigure,
  SkeletonAnimatable
{

  // MARK: - Constants

  private enum UI {
    // - iconImageView
    static let iconImageViewSize = CGSize(width: 38, height: 39)
    static let iconTopMargin: CGFloat = 15
    static let iconBottomMargin: CGFloat = 15
    static let iconLeadingMargin: CGFloat = 16

    // - textLabelStackView
    static let textLabelStackViewTopMargin: CGFloat = 3
    static let textLabelStackViewBottomMargin: CGFloat = 3
    static let textLabelStackViewLeadingMargin: CGFloat = 16
    static let textLabelStackViewTrailingMargin: CGFloat = 16
    static let textLabelStackViewSpacing: CGFloat = 2

    // - separatorLineView
    static let separatorLineViewHeight: CGFloat = 0.5

    enum Font {
      static let title = UIFont.systemFont(ofSize: 18)
      static let subtitle = UIFont.systemFont(ofSize: 15)
    }

    enum Color {
      static let iconImageViewBackground = UIColor.white
      static let titleText = UIColor.darkText
      static let subtitleText = UIColor.darkGray
      static let separatorLine = UIColor.lightGray
    }
  }

  // MARK: - Properties

  private(set) var viewModel: UserDetailInfoItemViewModel?

  // for skeleton view animation
  private let dummyTitleString = String(repeating: " ", count: 60)

  // MARK: - UI Components

  private let iconImageView = UIImageView().then {
    $0.tintColor = .gray
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = UI.Color.iconImageViewBackground
    $0.layer.cornerRadius = UI.iconImageViewSize.height / 2
    $0.isSkeletonable = true
  }

  private let titleLabel = UILabel().then {
    $0.font = UI.Font.title
    $0.textColor = UI.Color.titleText
    $0.numberOfLines = 0
    $0.isSkeletonable = true
  }

  private let subtitleLabel = UILabel().then {
    $0.font = UI.Font.subtitle
    $0.textColor = UI.Color.subtitleText
    $0.numberOfLines = 0
    $0.isSkeletonable = true
  }

  private let textLabelStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.distribution = .fill
    $0.spacing = UI.textLabelStackViewSpacing
  }

  private let separatorLineView = UIView().then {
    $0.backgroundColor = UI.Color.separatorLine
  }

  private(set) lazy var views: [UIView] = [
    iconImageView,
    titleLabel,
    subtitleLabel
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

  // MARK: - Internal methods

  func configure(by viewModel: UserDetailInfoItemViewModel) {
    self.viewModel = viewModel
    hideSkeletonAnimation()
    iconImageView.image = viewModel.icon
    titleLabel.text = viewModel.title
    separatorLineView.isHidden = !viewModel.showSeparatorLine

    guard viewModel.hasSubtitle else { return }
    subtitleLabel.text = viewModel.subtitle
    textLabelStackView.addArrangedSubview(subtitleLabel)
  }

  // MARK: - Private methods

  private func initUI() {
    iconImageView.image = nil
    titleLabel.text = dummyTitleString
    separatorLineView.isHidden = false
  }
}

// MARK: - Layout

extension UserDetailInfoCell {
  private func setupUI() {
    isSkeletonable = true
    contentView.addSubview(iconImageView)
    contentView.addSubview(textLabelStackView)
    contentView.addSubview(separatorLineView)
    textLabelStackView.addArrangedSubview(titleLabel)

    initUI()
    showSkeletonAnimation()
  }

  private func layout() {
    iconImageView.snp.makeConstraints {
      $0.size.equalTo(UI.iconImageViewSize)
      $0.centerY.equalToSuperview()
      $0.top.greaterThanOrEqualToSuperview().offset(UI.iconTopMargin)
      $0.bottom.lessThanOrEqualToSuperview().offset(-UI.iconBottomMargin)
      $0.leading.equalToSuperview().offset(UI.iconLeadingMargin)
    }

    textLabelStackView.snp.makeConstraints {
      $0.top.greaterThanOrEqualToSuperview()
      $0.bottom.lessThanOrEqualToSuperview()
      $0.leading.equalTo(iconImageView.snp.trailing).offset(UI.textLabelStackViewLeadingMargin)
      $0.trailing.equalToSuperview().offset(-UI.textLabelStackViewTrailingMargin)
      $0.centerY.equalToSuperview()
    }

    separatorLineView.snp.makeConstraints {
      $0.height.equalTo(UI.separatorLineViewHeight)
      $0.leading.equalTo(textLabelStackView.snp.leading)
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

#if canImport(SwiftUI) && DEBUG
  fileprivate extension UserDetailInfoCell {
    func dummyUserModel() -> UserModel? {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
      guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return nil }
      let userModelTranslator = UserModelTranslatorImpl()

      let userModels = userModelTranslator.translateToUserModel(by: randomUser.results)
      return userModels.first
    }
  }

  import SwiftUI

  @available(iOS 13.0, *)
  struct UserDetailInformationCellCellPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
      UIViewPreview {
        UserDetailInfoCell()
          .then {
            guard let userModel = $0.dummyUserModel() else { return }
            let viewModel: UserDetailInfoItemViewModel = UserDetailInfoItemViewModelImpl(
              userModel: userModel,
              icon: .checkmark,
              title: "서울",
              subtitle: "거주지",
              showSeparatorLine: true
            )
            $0.configure(by: viewModel)
          }
      }
      .previewLayout(.fixed(width: 400, height: 100))
      .padding(10)
    }
  }
#endif
