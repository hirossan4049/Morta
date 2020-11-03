//
//  Ranking.swift
//  morta
//
//  Created by unkonow on 2020/11/03.
//

import Foundation
import RealmSwift

class Ranking: Object{
    @objc dynamic var date: Date? = Date()
    @objc dynamic var time: Int = 0
    dynamic var routineList = List<RoutineItem>()
}

