//
//  RoutineItem.swift
//  morta
//
//  Created by unkonow on 2020/10/25.
//

import Foundation
import RealmSwift

class RoutineItem: Object{
    @objc dynamic var title: String? = ""
    @objc dynamic var index = 100
}
