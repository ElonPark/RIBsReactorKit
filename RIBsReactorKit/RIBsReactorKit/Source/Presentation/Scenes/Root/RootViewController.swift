//
//  RootViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/04/25.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

import RIBs
import RxSwift
import RxCocoa

protocol RootPresentableListener: class {
  var viewDidAppear: PublishRelay<Void> { get }
}

final class RootViewController:
  BaseViewController,
  RootPresentable,
  RootViewControllable
{
  
  // MARK: - Properties
  
  weak var listener: RootPresentableListener?
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    bindViewDidAppear()
  }
    
  // MARK: - Private methods

  private func bindViewDidAppear() {
    guard let listener = listener else { return }
    self.rx.viewDidAppear
      .take(1)
      .map { _ in Void() }
      .bind(to: listener.viewDidAppear)
      .disposed(by: disposeBag)
  }
}
