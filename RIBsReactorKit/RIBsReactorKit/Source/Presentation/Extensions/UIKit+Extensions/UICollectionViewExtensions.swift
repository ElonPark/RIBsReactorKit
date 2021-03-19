//
//  UICollectionViewExtensions.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

extension UICollectionView {
  func register<Cell: UICollectionViewCell>(_: Cell.Type) where Cell: Reusable {
    self.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
  }

  func register<View: UICollectionReusableView>(_: View.Type) where View: Reusable & HasElementKind {
    self.register(
      View.self,
      forSupplementaryViewOfKind: View.elementKind,
      withReuseIdentifier: View.identifier
    )
  }

  func dequeue<Cell: UICollectionViewCell>(_: Cell.Type, indexPath: IndexPath) -> Cell  where Cell: Reusable {
    if let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as? Cell {
      return cell
    } else {
      fatalError("Could not cast value of type 'UICollectionViewCell' to '\(String(describing: Cell.self))'")
    }
  }

  func dequeue<View: UICollectionReusableView>(
    _: View.Type,
    indexPath: IndexPath
  ) -> View where View: Reusable & HasElementKind {
    if let view =  self.dequeueReusableSupplementaryView(
      ofKind: View.elementKind,
      withReuseIdentifier: View.identifier,
      for: indexPath
    ) as? View {
      return view
    } else {
      fatalError("Could not cast value of type 'UICollectionReusableView' to '\(String(describing: View.self))'")
    }
  }
}
