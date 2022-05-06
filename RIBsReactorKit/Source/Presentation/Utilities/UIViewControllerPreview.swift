//
//  UIViewControllerPreview.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
  import SwiftUI

  struct UIViewControllerPreview<ViewController: UIViewController>: UIViewControllerRepresentable {
    let viewController: ViewController

    init(_ builder: @escaping () -> ViewController) {
      self.viewController = builder()
    }

    // MARK: - UIViewControllerRepresentable

    func makeUIViewController(context: Context) -> ViewController {
      self.viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
  }
#endif
