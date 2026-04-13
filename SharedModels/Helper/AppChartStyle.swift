//
//  AppChartStyle.swift
//  Spendora
//
//  Created by Pratik Goel on 14/04/26.
//


import SwiftUI
import Charts

struct AppChartStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
        // ✅ Fix background (critical for dark mode)
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
            }
        
        // ✅ Fix X Axis
            .chartXAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                        .foregroundStyle(.primary)
                }
            }
        
        // ✅ Fix Y Axis
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                        .foregroundStyle(.primary)
                }
            }
    }
}
