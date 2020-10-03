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
  func makeSections(from factories: [UserInfomationSectionFactory]) -> [UserInfomationSection]
}

struct UserInfomationSectionListFactoryImpl: UserInfomationSectionListFactory {
  
  let userModel: UserModel
  
  func makeSections(from factories: [UserInfomationSectionFactory]) -> [UserInfomationSection] {
    return factories.map { $0.makeSection(from: userModel) }
  }
}
