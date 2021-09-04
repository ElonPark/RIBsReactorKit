//
//  UIImageViewExtensions.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/05.
//  Copyright © 2021 Elon. All rights reserved.
//

import UIKit

import Kingfisher

extension UIImageView {
  func setImage(with url: URL?) {
    kf.setImage(with: url)
  }

  func cancelDownloadTask() {
    kf.cancelDownloadTask()
  }
}
