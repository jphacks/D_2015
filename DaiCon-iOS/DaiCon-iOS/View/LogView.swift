//
//  LogView.swift
//  DaiCon-iOS
//
//  Created by 中岡黎 on 2020/11/01.
//

import SwiftUI
import SwiftUICharts
import QGrid

struct LogView: View {
    @EnvironmentObject var fireViewModel: FireViewModel
    var body: some View {
        NavigationView {
            QGrid(trainingList, columns: 2) {training in
                BarChartView(data: ChartData(values: self.fireViewModel.logList[training.name]! as! Array<(String, Int)>),
                             title: training.name,
                             legend: "count",
                             valueSpecifier: "%.f")
                    .padding()
            }
                .navigationTitle("Life Log")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView().environmentObject(FireViewModel())
    }
}
