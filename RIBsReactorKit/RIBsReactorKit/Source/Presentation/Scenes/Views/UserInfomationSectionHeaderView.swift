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
    
    enum Font {
      
    }
  }
  
  // MARK: - Properties
  
  var viewModel: UserInfomationSectionHeaderViewModel? {
    didSet {
      guard let viewModel = viewModel else { return }
      titleLabel.text = viewModel.title
    }
  }
  
  // for skeleton view animation
  private let dummyTitleString = String(repeating: " ", count: 60)
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.isSkeletonable = true
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

  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct UserInfomationSectionHeaderViewPreview: PreviewProvider {
  static var previews: some SwiftUI.View {
    UIViewPreview {
      UserInfomationSectionHeaderView()
    }
    .previewLayout(.fixed(width: 250, height: 320))
    .padding(10)
  }
}
#endif
