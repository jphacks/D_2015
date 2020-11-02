//
//  SettingView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI
import QGrid

struct SettingView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    
    var body: some View {
        NavigationView {
            QGrid(fireViewModel.settingList, columns: 3) {tvCommand in
                GridCell(tvCommand: tvCommand)
            }
                .navigationTitle("Setting")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
