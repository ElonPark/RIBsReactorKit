//
//  UserInfoSectionListFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

// MARK: - UserInfoSectionItemFactory

protocol UserInfoSectionItemFactory {
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem
}

// MARK: - UserInfoSectionFactory

protocol UserInfoSectionFactory {
  func makeSection(from userModel: UserModel) -> UserInfoSectionModel
}

// MARK: - UserInfoSectionListFactory

protocol UserInfoSectionListFactory {
  func makeSections(by userModel: UserModel) -> [UserInfoSectionModel]
}

// MARK: - UserInfoSectionListFactoryImpl

struct UserInfoSectionListFactoryImpl: UserInfoSectionListFactory {

  private let factories: [UserInfoSectionFactory]

  init(factories: [UserInfoSectionFactory]) {
    self.factories = factories
  }

  func makeSections(by userModel: UserModel) -> [UserInfoSectionModel] {
    self.factories.map { $0.makeSection(from: userModel) }
  }
}
