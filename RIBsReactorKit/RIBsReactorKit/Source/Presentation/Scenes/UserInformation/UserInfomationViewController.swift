//
//  UserInfomationViewController.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/06/23.
//  Copyright © 2020 Elon. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol UserInfomationPresentableListener: class {
  func dettach()
}

final class UserInfomationViewController:
  BaseViewController,
  UserInfomationPresentable,
  UserInfomationViewControllable
{
  
  // MARK: - Constants
  
  private enum UI {
    
  }
  
  // MARK: - Properties
  
  weak var listener: UserInfomationPresentableListener?
  
  // MARK: - UI Components
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    guard isMovingFromParent || isBeingDismissed else { return }
    // FIXME: - fix after implementation UserInfomationRIB 2020-06-28 03:10:51
    listener?.dettach()
  }
  
   // MARK: - Binding
  
  // MARK: - Private methods
}

// MARK: - Layout
extension UserInfomationViewController {
  private func setupUI() {
    view.backgroundColor = .white
    
    layout()
  }
  
  private func layout() {

  }
}

#if canImport(SwiftUI) && DEBUG
extension UserInfomationViewController {
  fileprivate func bindDummyUserModel() {
    let decoder = JSONDecoder()
    guard let randomUser = try? decoder.decode(RandomUser.self, from: RandomUserFixture.data) else { return }
    let userModelTranslator = UserModelTranslatorImpl()
    
    let userModel = userModelTranslator.translateToUserModel(by: randomUser.results).first
    
  }
}

import SwiftUI

private let deviceNames: [String] = [
  "iPhone SE",
  "iPhone 11 Pro Max"
]

@available(iOS 13.0, *)
struct UserInfomationViewControllerPreview: PreviewProvider {
  
  static var previews: some SwiftUI.View {
    ForEach(deviceNames, id: \.self) { deviceName in
      UIViewControllerPreview {
        let viewController = UserInfomationViewController().then {
          $0.bindDummyUserModel()
        }
        return UINavigationController(rootViewController: viewController)
      }
      .previewDevice(PreviewDevice(rawValue: deviceName))
      .previewDisplayName(deviceName)
    }
  }
}
#endif
