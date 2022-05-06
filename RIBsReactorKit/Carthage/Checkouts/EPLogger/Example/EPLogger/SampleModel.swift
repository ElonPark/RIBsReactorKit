//
//  SampleModel.swift
//  EPLogger_Example
//
//  Created by Elon on 2020/03/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

struct SampleStruct {
    let id: Int = 456231
    let userName: String = "User name"
    let height: Double = 181.2
}

enum SampleEnum {
    case firstCase
}

enum StringEnum: String {
    case normal
    case vip = "VIP"
    case vvip = "VVIP"
}

enum IntEnum: Int {
    case one = 1
    case two
}
