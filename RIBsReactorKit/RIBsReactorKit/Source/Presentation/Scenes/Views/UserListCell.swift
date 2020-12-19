//
//  UserListCell.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/06.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import Then
import Kingfisher
import SnapKit
import SkeletonView

class UserListCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  private enum UI {
    static let profileImageViewTopMargin: CGFloat = 8
    static let profileImageViewBottomMargin: CGFloat = 8
    static let profileImageViewLeadingMargin: CGFloat = 8
    static var profileImageViewSize: CGSize { CGSize(width: 50, height: 50) }
    
    static let nameLabelTopMargin: CGFloat = 10
    static let nameLabelLeadingMargin: CGFloat = 8
    static let nameLabeltrailingMargin: CGFloat = 8
    
    static let locationLabelTopMargin: CGFloat = 5
    static let locationLabelBottomMargin: CGFloat = 8
    static let locationLabeltrailingMargin: CGFloat = 8
  }
  
  // MARK: - Properties
  
  // for skeleton view animation
  let dummyNameString = String(repeating: " ", count: 60)
  let dummylocationString = String(repeating: " ", count: 40)
  
  // MARK: - UI Components
  
  private let profileImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = UI.profileImageViewSize.height / 2
    $0.isSkeletonable = true
  }
  
  private let nameLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 17, weight: .medium)
    $0.isSkeletonable = true
  }
  
  private let locationLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 15, weight: .regular)
    $0.textColor = .darkText
    $0.isSkeletonable = true
  }
  
  private var views: [UIView] {
    [
      profileImageView,
      nameLabel,
      locationLabel
    ]
  }
  
  // MARK: - Inheritance
  
  override func initialize() {
    super.initialize()
    setUpUI()
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
  
  func configuration(by userModel: UserModel?) {
    guard let userModel = userModel else { return }
    hideSkeleton()
    setProfileImageView(by: userModel.thumbnailImageURL)
    setUserName(by: userModel)
    setLocation(by: userModel)
  }
  
  // MARK: - Private methods
  
  private func initUI() {
    profileImageView.image = nil
    nameLabel.text = dummyNameString
    locationLabel.text = dummylocationString
  }
  
  private func setProfileImageView(by url: URL?) {
    profileImageView.kf.setImage(with: url)
  }
  
  private func setUserName(by userModel: UserModel) {
    let name = "\(userModel.name.title). \(userModel.name.first) \(userModel.name.last)"
    nameLabel.text = name
  }
  
  private func setLocation(by userModel: UserModel) {
    let location = "\(userModel.location.city) \(userModel.location.state) \(userModel.location.country)"
    locationLabel.text = location
  }
  
  private func showSkeletonAnimation() {
    views.forEach { $0.showAnimatedGradientSkeleton() }
  }
  
  private func hideSkeletonAnimation() {
    views.forEach {
      if $0.isSkeletonActive {
        $0.hideSkeleton(transition: .crossDissolve(0.25))
      }
    }
  }
}

// MARK: - Layout
extension UserListCell {
  private func setUpUI() {
    self.selectionStyle = .none
    self.isSkeletonable = true
    
    views.forEach { self.contentView.addSubview($0) }
    
    initUI()
    showSkeletonAnimation()
  }
  
  private func layout() {
    profileImageView.snp.makeConstraints {
      $0.width.equalTo(UI.profileImageViewSize.width)
      $0.height.equalTo(UI.profileImageViewSize.height).priority(.high)
      $0.top.equalToSuperview().offset(UI.profileImageViewTopMargin)
      $0.bottom.equalToSuperview().offset(-UI.profileImageViewBottomMargin)
      $0.leading.equalToSuperview().offset(UI.profileImageViewLeadingMargin)
    }
    
    nameLabel.snp.makeConstraints {
      $0.top.equalTo(profileImageView.snp.top)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(UI.nameLabelLeadingMargin)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.nameLabeltrailingMargin)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(nameLabel.snp.bottom).offset(UI.locationLabelTopMargin)
      $0.bottom.lessThanOrEqualTo(profileImageView.snp.bottom)
      $0.leading.equalTo(nameLabel.snp.leading)
      $0.trailing.lessThanOrEqualToSuperview().offset(-UI.locationLabeltrailingMargin)
    }
  }
}
