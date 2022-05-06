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

  struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View

    init(_ builder: @escaping () -> View) {
      self.view = builder()
    }

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> UIView {
      self.view
    }

    func updateUIView(_ view: UIView, context: Context) {
      view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
  }
#endif
