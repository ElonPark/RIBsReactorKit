//
//  ImagePrefetchWorker.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/09/14.
//  Copyright © 2021 Elon. All rights reserved.
//

import Kingfisher
import RIBs

// MARK: - ImagePrefetchWorking

protocol ImagePrefetchWorking: Working {
  func startPrefetch(withURLs urls: [URL])
}

// MARK: - ImagePrefetchWorker

final class ImagePrefetchWorker: Worker, ImagePrefetchWorking {

  func startPrefetch(withURLs urls: [URL]) {
    guard !urls.isEmpty else { return }
    Kingfisher.ImagePrefetcher(urls: urls).start()
  }
}
