//
//  Utils.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/04/03.
//

import Foundation

class Utils {
    static func copy<T>(_ object: T) -> T {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)) as! T
        } catch let error {
            fatalError("ViewUtils.copy<T>(_ object: T) \(error.localizedDescription)")
        }
    }
}
