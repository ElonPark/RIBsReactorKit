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

class UserListCell:
  BaseTableViewCell,
  SkeletonAnimatable
{
  
  // MARK: - Constants
  
  private enum UI {
    // - profileImageView
    static let profileImageViewTopMargin: CGFloat = 8
    static let profileImageViewBottomMargin: CGFloat = 8
    static let profileImageViewLeadingMargin: CGFloat = 8
    static let profileImageViewSize: CGSize = CGSize(width: 50, height: 50)
    
    // - nameLabel
    static let nameLabelTopMargin: CGFloat = 10
    static let nameLabelLeadingMargin: CGFloat = 8
    static let nameLabelTrailingMargin: CGFloat = 8
    
    // - locationLabel
    static let locationLabelTopMargin: CGFloat = 5
    static let locationLabelBottomMargin: CGFloat = 8
    static let locationLabelTrailingMargin: CGFloat = 8
  }
  
  // MARK: - Properties
  
  // for skeleton view animation
  private let dummyNameString = String(repeating: " ", count: 60)
  private let dummylocationString = String(repeating: " ", count: 40)
  
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
  
  private(set) lazy var views: [UIView] = [
    profileImageView,
    nameLabel,
    locationLabel
  ]
  
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
    setProfileImageView(by: userModel)
    setUserNameLabel(by: userModel)
    setLocationLabel(by: userModel)
  }
  
  // MARK: - Private methods
  
  private func initUI() {
    profileImageView.image = nil
    nameLabel.text = dummyNameString
    locationLabel.text = dummylocationString
  }
  
  private func setProfileImageView(by userModel: UserModel) {
    profileImageView.kf.setImage(with: userModel.thumbnailImageURL)
  }
  
  private func setUserNameLabel(by userModel: UserModel) {
    let name = "\(userModel.name.title). \(userModel.name.first) \(userModel.name.last)"
    nameLabel.text = name
  }
  
  private func setLocationLabel(by userModel: UserModel) {
    let location = "\(userModel.location.city) \(userModel.location.state) \(userModel.location.country)"
    locationLabel.text = location
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
      $0.height.equalTo(UI.profileImageViewSize.height)
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

@available(iOS 13.0, *)
struct UserListCellPreview: PreviewProvider {
  static var previews: some SwiftUI.View {
    UIViewPreview {
      UserListCell()
    }
    .previewLayout(.fixed(width: 320, height: 100))
    .padding(10)
  }
}
#endif
