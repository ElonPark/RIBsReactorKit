//
//  UITableViewExtensions.swift
//  Smithsonian
//
//  Created by Elon on 2020/03/07.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

extension UITableView {
  func register<Cell: UITableViewCell>(_: Cell.Type) where Cell: Reusable {
    self.register(Cell.self, forCellReuseIdentifier: Cell.identifier)
  }
  
  func register<View: UITableViewHeaderFooterView>(_: View.Type) where View: Reusable {
    self.register(View.self, forHeaderFooterViewReuseIdentifier: View.identifier)
  }
  
  // swiftlint:disable force_cast
  func dequeue<Cell: UITableViewCell>(
    _: Cell.Type,
    indexPath: IndexPath
  ) -> Cell where Cell: Reusable {
    return self.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
  }
  
  func dequeue<View: UITableViewHeaderFooterView>(_: View.Type) -> View where View: Reusable {
    return self.dequeueReusableHeaderFooterView(withIdentifier: View.identifier) as! View
  }
  // swiftlint:enable force_cast
}
