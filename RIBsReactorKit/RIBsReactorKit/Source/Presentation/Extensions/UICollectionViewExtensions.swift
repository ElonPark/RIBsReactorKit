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
    
  func register<View: UICollectionReusableView>(
    _: View.Type
  ) where View: Reusable & HasElementKind {
    self.register(
      View.self,
      forSupplementaryViewOfKind: View.elementKind,
      withReuseIdentifier: View.identifier
    )
  }
  
  // swiftlint:disable force_cast
  func dequeue<Cell: UICollectionViewCell>(
    _: Cell.Type,
    indexPath: IndexPath
  ) -> Cell  where Cell: Reusable {
    return self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath) as! Cell
  }
  
  func dequeue<View: UICollectionReusableView>(
    _: View.Type,
    indexPath: IndexPath
  ) -> View where View: Reusable & HasElementKind {
    return self.dequeueReusableSupplementaryView(
      ofKind: View.elementKind,
      withReuseIdentifier: View.identifier,
      for: indexPath
      ) as! View
  }
  // swiftlint:enable force_cast
}
