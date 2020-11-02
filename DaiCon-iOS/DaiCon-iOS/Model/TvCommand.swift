//
//  TvCommand.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import Foundation

struct TvCommand: Identifiable {
    var id = UUID()
    var name: String
    var setting: [String: Any]
}
