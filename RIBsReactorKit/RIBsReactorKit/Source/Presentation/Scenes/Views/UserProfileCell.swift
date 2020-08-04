//
//  UserProfileCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/08/03.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

final class UserProfileCell:
  BaseCollectionViewCell,
  SkeletonAnimatable
{

  // MARK: - Constants

  private enum UI {
    static let profileBackgroundImageViewCornerRadius: CGFloat = 18
    static let profileBackgroundImageViewHeight: CGFloat = 120
    
    static let profileImageViewSize: CGSize = .init(width: 120, height: 120)
    static let profileImageViewBorderWidth: CGFloat = 5
    
    static let labelMinimumSideMargin: CGFloat = 16
    static let titleWithLastNameLabelTopMargin: CGFloat = 8
    static let firstNameLabelTopMargin: CGFloat = 3
    static let firstNameLabelBottomMargin: CGFloat = 8
    
    enum Font {
      static let titleWithLastNameLabel: UIFont = .systemFont(ofSize: 20, weight: .bold)
      static let firstNameLabel: UIFont = .systemFont(ofSize: 15)
    }
  }

  // MARK: - Properties

  // for skeleton view animation
  private let dummyTitleWithLastNameString = String(repeating: " ", count: 60)
  private let dummyFirstNameString = String(repeating: " ", count: 40)

  // MARK: - UI Components

  private let profileBackgroundImageView = BlurEffectImageView().then {
    $0.blurStyle = .light
    $0.contentMode = .scaleAspectFill
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = UI.profileBackgroundImageViewCornerRadius
    $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    $0.isSkeletonable = true
  }

  private let profileImageView = UIImageView().then {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
    $0.layer.borderWidth = UI.profileImageViewBorderWidth
    $0.layer.borderColor = UIColor.white.cgColor
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = UI.profileImageViewSize.height / 2
    $0.isSkeletonable = true
  }

  private let titleWithLastNameLabel = UILabel().then {
    $0.font = UI.Font.titleWithLastNameLabel
    $0.textAlignment = .center
    $0.isSkeletonable = true
  }
  
  private let firstNameLabel = UILabel().then {
    $0.font = UI.Font.firstNameLabel
    $0.textAlignment = .center
    $0.isSkeletonable = true
  }
  
  private(set) lazy var views: [UIView] = [
    profileBackgroundImageView,
    profileImageView,
    titleWithLastNameLabel,
    firstNameLabel
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

  func configuration(by userModel: UserModel?) {
    guard let userModel = userModel else { return }
    hideSkeleton()
    setProfileBackgroundImageBlurView(by: userModel)
    setProfileImageView(by: userModel)
    setTitleWithLastNameLabel(by: userModel)
    setFirstNameLabel(by: userModel)
  }

  // MARK: - Private methods

  private func initUI() {
    profileBackgroundImageView.image = nil
    profileImageView.image = nil
    titleWithLastNameLabel.text = dummyTitleWithLastNameString
    firstNameLabel.text = dummyFirstNameString
  }
  
  private func setProfileBackgroundImageBlurView(by userModel: UserModel) {
    profileBackgroundImageView.kf.setImage(with: userModel.largeImageURL)
  }
  
  private func setProfileImageView(by userModel: UserModel) {
    profileImageView.kf.setImage(with: userModel.mediumImageURL)
  }
  
  private func setTitleWithLastNameLabel(by userModel: UserModel) {
    let name = "\(userModel.name.title). \(userModel.name.last)"
    titleWithLastNameLabel.text = name
  }
  
  private func setFirstNameLabel(by userModel: UserModel) {
    firstNameLabel.text = userModel.name.first
  }
}

// MARK: - Layout
extension UserProfileCell {
  private func setupUI() {
    self.isSkeletonable = true
    
    views.forEach { self.contentView.addSubview($0) }
    
    initUI()
    showSkeletonAnimation()
  }

  private func layout() {
    profileBackgroundImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
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
