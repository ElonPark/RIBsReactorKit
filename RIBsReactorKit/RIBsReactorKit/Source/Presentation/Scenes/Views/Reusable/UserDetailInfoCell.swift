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
    // - baseContentsView
    static var baseContentsViewWidth: CGFloat { UIScreen.main.bounds.width }
    static let baseContentsViewMinimumHeight: CGFloat = 80

    // - iconImageView
    static var iconImageViewSize: CGSize { CGSize(width: 40, height: 40) }
    static let iconTopMargin: CGFloat = 15
    static let iconBottomMargin: CGFloat = 15
    static let iconLeadingMargin: CGFloat = 8

    // - textLabelStackView
    static let textLabelStackViewTopMargin: CGFloat = 3
    static let textLabelStackViewBottomMargin: CGFloat = 3
    static let textLabelStackViewLeadingMargin: CGFloat = 8
    static let textLabelStackViewTrailingMargin: CGFloat = 8
    static let textLabelStackViewSpacing: CGFloat = 0

    // - separatorLineView
    static let separatorLineViewHeight: CGFloat = 0.5

    enum Font {
      static var title: UIFont { .systemFont(ofSize: 20) }
      static var subtitle: UIFont { .systemFont(ofSize: 15) }
    }

    enum Color {
      static var iconImageViewBackground: UIColor { .skeletonDefault }
      static var titleText: UIColor { .darkText }
      static var subtitleText: UIColor { .darkGray }
      static var separatorLine: UIColor { .lightGray }
    }
  }

  // MARK: - Properties

  private(set) var viewModel: UserDetailInfoItemViewModel?

  // for skeleton view animation
  private let dummyTitleString = String(repeating: " ", count: 60)

  // MARK: - UI Components

  private let baseContentsView = UIView()

  private let iconImageView = UIImageView().builder
    .tintColor(.gray)
    .contentMode(.scaleAspectFill)
    .backgroundColor(UI.Color.iconImageViewBackground)
    .set(\.layer.cornerRadius, to: UI.iconImageViewSize.height / 2)
    .isSkeletonable(true)
    .build()

  private let titleLabel = UILabel().builder
    .font(UI.Font.title)
    .textColor(UI.Color.titleText)
    .numberOfLines(0)
    .isSkeletonable(true)
    .build()

  private let subtitleLabel = UILabel().builder
    .font(UI.Font.subtitle)
    .textColor(UI.Color.subtitleText)
    .numberOfLines(0)
    .isSkeletonable(true)
    .build()

  private let textLabelStackView = UIStackView().builder
    .axis(.vertical)
    .alignment(.fill)
    .distribution(.fill)
    .spacing(UI.textLabelStackViewSpacing)
    .build()

  private let separatorLineView = UIView().builder
    .backgroundColor(UI.Color.separatorLine)
    .build()

  private(set) lazy var views: [UIView] = [
    baseContentsView,
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
    contentView.addSubview(baseContentsView)
    baseContentsView.addSubview(iconImageView)
    baseContentsView.addSubview(textLabelStackView)
    baseContentsView.addSubview(separatorLineView)
    textLabelStackView.addArrangedSubview(titleLabel)

    initUI()
    showSkeletonAnimation()
  }

  private func layout() {
    baseContentsView.snp.makeConstraints {
      $0.width.equalTo(UI.baseContentsViewWidth)
      $0.height.greaterThanOrEqualTo(UI.baseContentsViewMinimumHeight)
      $0.edges.equalToSuperview().priority(.high)
    }

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
        UserDetailInfoCell().builder
          .reinforce {
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
