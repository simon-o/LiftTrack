//
//  ListGrpahTableViewCell.swift
//  LiftTrack
//
//  Created by Antoine Simon on 10/07/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import Charts

class ListGrpahTableViewCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var chartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chartView.delegate = self
        chartView.animate(yAxisDuration: 2.5, easingOption: .easeOutCubic)
        chartView.chartDescription?.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.enabled = false
        chartView.legend.enabled = false
        
        chartView.leftAxis.axisLineColor = UIColor.white
        chartView.leftAxis.labelTextColor = UIColor.white
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
    }
    
    func updateChart(_ finalData: [String]){
        chartView.animate(yAxisDuration: 2.5, easingOption: .easeOutCubic)
        
        var dataEntries = [ChartDataEntry]()
        var count = 0.0
        for element in finalData{
            let tmp = ChartDataEntry(x: count, y: Double(element) ?? 0.0)
            dataEntries.append(tmp)
            count += 1.0
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.mode = .cubicBezier
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setValueTextColor(UIColor.gray)
        chartData.setDrawValues(true)
        chartView.data = chartData
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
