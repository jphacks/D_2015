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
    var chartDataList: [ChartData] = [ChartData(values: [("2018 01/01",10),
                                                        ("2019 01/01",4),
                                                        ("2019 01/01",0),
                                                        ("2019 01/01",8),
                                                        ("2019 01/01",20),
                                                        ("2019 01/01",20),
                                                        ("2019 01/01",20),
                                                        ("2019 01/01",20)]),
                                      ChartData(values: [("2018 01/01",10),
                                                         ("2019 01/01",4),
                                                         ("2019 01/01",0),
                                                         ("2019 01/01",8),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20)]),
                                      ChartData(values: [("2018 01/01",10),
                                                         ("2019 01/01",4),
                                                         ("2019 01/01",0),
                                                         ("2019 01/01",8),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20),
                                                         ("2019 01/01",20)])]
    var body: some View {
        NavigationView {
            QGrid(chartDataList, columns: 2) {chartData in
                BarChartView(data: chartData, title: "腹筋", legend: "count",
                             valueSpecifier: "%.f")
                    .padding()
            }
                .navigationTitle("Life Log")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
