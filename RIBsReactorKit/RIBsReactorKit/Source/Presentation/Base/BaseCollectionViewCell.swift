//
//  BaseCollectionViewCell.swift
//  Smithsonian
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxSwift

class BaseCollectionViewCell: UICollectionViewCell, Reusable {

  // MARK: - Properties
  
  var disposeBag: DisposeBag = DisposeBag()

  private(set) var didSetupConstraints = false
  
  // MARK: - Initialization & Deinitialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  // MARK: - Inheritance
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  // MARK: - Layout Constraints
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    
    super.updateConstraints()
  }
  
  // MARK: - Internal methods

  func initialize() {
    // Override point
    self.setNeedsUpdateConstraints()
  }
  
  /// Override this method, if need to set Autolayout constraints
  func setupConstraints() {
    // Override here
  }
}
