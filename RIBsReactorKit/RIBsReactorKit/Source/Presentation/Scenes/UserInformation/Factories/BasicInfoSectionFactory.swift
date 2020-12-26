//
//  BasicInfoSectionFactory.swift
//  RIBsReactorKit
//
//  Created by Elon on 2020/10/04.
//  Copyright © 2020 Elon. All rights reserved.
//

import UIKit

struct BasicInfoSectionFactory: UserInfoSectionFactory {
  
  let factories: [UserInfoSectionItemFactory] = [
    GenderSctionItemFactory(),
    BirthDateSctionItemFactory(),
    AgeSctionItemFactory()
  ]
  
  func makeSection(from userModel: UserModel) -> UserInfoSectionModel {
    let headerViewModel = UserInfoSectionHeaderViewModel(title: "기본 정보")
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

struct GenderSctionItemFactory: UserInfoSectionItemFactory {
  
  private var icon: UIImage? {
    guard #available(iOS 13, *) else { return nil }
    return UIImage(systemName: "person.fill")
  }
  
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      icon: icon,
      title: userModel.gender,
      subtitle: "성별",
      showSeparatorLine: !isLastItem
    )
    
    return .detail(viewModel)
  }
}

struct BirthDateSctionItemFactory: UserInfoSectionItemFactory {
  
  private var icon: UIImage? {
    guard #available(iOS 13, *) else { return nil }
    return UIImage(systemName: "calendar")
  }
  
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      icon: icon,
      title: dateFormatString(from: userModel.dob.date),
      subtitle: "생일",
      showSeparatorLine: true
    )
    
    return .detail(viewModel)
  }
  
  private func dateFormatString(from date: Date) -> String {
    let dateFormatter = DateFormatter().then {
      $0.dateStyle = .short
      $0.timeStyle = .none
    }
    return dateFormatter.string(from: date)
  }
}

struct AgeSctionItemFactory: UserInfoSectionItemFactory {
  
  private var icon: UIImage? {
    guard #available(iOS 13, *) else { return nil }
    return UIImage(systemName: "clock")
  }
  
  func makeSectionItem(from userModel: UserModel, isLastItem: Bool) -> UserInfoSectionItem {
    let viewModel = UserDetailInfoItemViewModel(
      icon: icon,
      title: "\(userModel.dob.age)세",
      subtitle: "나이",
      showSeparatorLine: false
    )
    
    return .detail(viewModel)
  }
}
