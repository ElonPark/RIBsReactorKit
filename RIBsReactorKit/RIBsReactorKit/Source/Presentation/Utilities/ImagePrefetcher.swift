//
//  ImagePrefetcher.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/05.
//  Copyright © 2021 Elon. All rights reserved.
//

import Foundation

import Kingfisher

final class ImagePrefetcher {

  func startPrefetch(withURLs urls: [URL]) {
    Kingfisher.ImagePrefetcher(urls: urls).start()
  }
}
