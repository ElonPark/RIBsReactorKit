//
//  UserInfomationSectionListFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

protocol UserInfomationSectionItemFactory {
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfomationSectionItem
}

protocol UserInfomationSectionFactory {
  func makeSection(from userModel: UserModel) -> UserInfomationSection
}

protocol UserInfomationSectionListFactory {
  func makeSections(by userModel: UserModel) -> [UserInfomationSection]
}

struct UserInfomationSectionListFactoryImpl: UserInfomationSectionListFactory {
  
  private let factories: [UserInfomationSectionFactory]
  
  init(factories: [UserInfomationSectionFactory]) {
    self.factories = factories
  }
  
  func makeSections(by userModel: UserModel) -> [UserInfomationSection] {
    return factories.map { $0.makeSection(from: userModel) }
  }
}
