//
//  BaseTableViewCell.swift
//  Smithsonian
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RxSwift

class BaseTableViewCell: UITableViewCell, Reusable {
  
  // MARK: - Properties
  
  var disposeBag: DisposeBag = DisposeBag()

  private(set) var didSetupConstraints = false
  
  // MARK: - Initialization & Deinitialization
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    if !didSetupConstraints {
      setupConstraints()
      didSetupConstraints = true
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
