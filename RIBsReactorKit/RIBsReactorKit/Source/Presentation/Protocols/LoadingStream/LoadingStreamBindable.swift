//
//  LoadingStreamBindable.swift
//  RIBsReactorKit
//
//  Created by elon on 2021/08/17.
//  Copyright © 2021 Elon. All rights reserved.
//

import RxSwift

// MARK: - LoadingStreamBindable

protocol LoadingStreamBindable: AnyObject {
  func bindLoadingStream(from listener: HasLoadingStream)
}

extension LoadingStreamBindable where Self: HasTableView & HasDisposeBag & SkeletonControllable {
  func bindLoadingStream(from listener: HasLoadingStream) {
    listener.isLoadingStream
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { this, isLoading in
        this.skeletonView(this.tableView, shouldStartAnimationWhen: isLoading)
      }
      .disposed(by: disposeBag)
  }
}

extension LoadingStreamBindable where Self: HasCollectionView & HasDisposeBag & SkeletonControllable {
  func bindLoadingStream(from listener: HasLoadingStream) {
    listener.isLoadingStream
      .distinctUntilChanged()
      .withUnretained(self)
      .bind { this, isLoading in
        this.skeletonView(this.collectionView, shouldStartAnimationWhen: isLoading)
      }
      .disposed(by: disposeBag)
  }
}
