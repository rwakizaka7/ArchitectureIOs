//
//  EClass.swift
//  CalendarIOs
//
//  Created by 脇坂亮汰 on 2020/07/19.
//  Copyright © 2020 脇坂亮汰. All rights reserved.
//

import Foundation

protocol EClass {}

extension EClass {
    static var className: String {
        get {
            return String(describing: type(of: self))
                .replacingOccurrences(of: ".Type", with: "")
        }
    }

    var className: String {
        get {
            return String(describing: type(of: self))
        }
    }
}
