//
//  BasicInfoSectionFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct BasicInfoSectionFactory: UserInfoSectionFactory {
  
  let factories: [UserInfoSectionItemFactory] = [
    GenderSctionItemFactory(),
    BirthDateSctionItemFactory(),
    AgeSctionItemFactory()
  ]
  
  func makeSection(from userModel: UserModel) -> UserInfoSectionModel {
    let headerViewModel: UserInfoSectionHeaderViewModel = UserInfoSectionHeaderViewModelImpl(title: "기본 정보")
    let items = factories.enumerated().map {
      $0.element.makeSectionItem(from: userModel, isLastItem: $0.offset == factories.endIndex)
    }
    
    let section = UserInfoSectionModel(
      header: headerViewModel,
      hasFooter: true,
      items: items
    )
    
    return section
  }
}
