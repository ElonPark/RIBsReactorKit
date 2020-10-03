//
//  EmptyReusableView.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

final class EmptyReusableView:
  UICollectionReusableView,
  Reusable,
  HasElementKind
{
  static var elementKind: String = "empty"
}
