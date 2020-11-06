//
//  Helper.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/02.
//

import Foundation

struct Training: Identifiable {
    var id = UUID()
    var name: String
}

let trainingList = [Training(name: "腹筋"),
                    Training(name: "腕立て"),
                    Training(name: "スクワット"),
                    Training(name: "背筋"),
                    Training(name: "縄跳び")]

struct Program: Identifiable {
    var id = UUID()
    var proTime: String
    var proStation: String
    var proTitle: String
    var proDetail: String
}
