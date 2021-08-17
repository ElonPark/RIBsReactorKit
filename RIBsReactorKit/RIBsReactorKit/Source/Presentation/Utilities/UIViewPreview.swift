//
//  UIViewPreview.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/05/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
  import SwiftUI
  @available(iOS 13.0, *)
  struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
      self.view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
      view
    }

    func updateUIView(_ view: UIView, context: Context) {
      view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
  }
#endif
