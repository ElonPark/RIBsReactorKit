//
//  UserInfoSectionListFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

protocol UserInfoSectionItemFactory {
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem
}

protocol UserInfoSectionFactory {
  func makeSection(from userModel: UserModel) -> UserInfoSectionModel
}

protocol UserInfoSectionListFactory {
  func makeSections(by userModel: UserModel) -> [UserInfoSectionModel]
}

struct UserInfoSectionListFactoryImpl: UserInfoSectionListFactory {
  
  private let factories: [UserInfoSectionFactory]
  
  init(factories: [UserInfoSectionFactory]) {
    self.factories = factories
  }
  
  func makeSections(by userModel: UserModel) -> [UserInfoSectionModel] {
    return factories.map { $0.makeSection(from: userModel) }
  }
}
