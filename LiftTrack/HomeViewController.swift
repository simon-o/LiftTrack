//
//  HomeViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 20/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase
import Charts

class HomeViewController: UIViewController, ChartViewDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var tableView: UITableView!
    
    let formatter = DateFormatter()
    var selectedDate = Date()
    var allDate = [String]()
    var ref = FIRDatabase.database().reference()
    var hadFindToday = false
    var listSelected = [Int:Any]()
    var isAdding = false
    
    var counteur = Array(repeating: 0, count: 6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let today = Date()
        calendarView?.scrollToDate(today)
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.pinchZoomEnabled = false
        chartView.dragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = true
        chartView.xAxis.enabled = true
        chartView.xAxis.labelTextColor = UIColor.white
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.axisLineColor = UIColor.white
        chartView.legend.enabled = false
        chartView.leftAxis.axisLineColor = UIColor.white
        chartView.leftAxis.labelTextColor = UIColor.white
        
        calendarView.visibleDates { (visibleDates) in
            self.displayMonthYear(visibleDates: visibleDates)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parseDate()
        if (isAdding == true){
            parseSelected(selectedDate)
            isAdding = false
        }
    }
    
    func updateChartWithData(){
        if (hadFindToday == true){
            chartView.animate(yAxisDuration: 2.5, easingOption: .easeOutCubic)
            let format = NumberFormatter()
            format.positivePrefix = "sem "
            chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: format)
            
            var count = Array(repeating: 0, count: 6)
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(secondsFromGMT: 2*60*60)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            
            DispatchQueue.init(label: "queue1").async {
                let unique = self.allDate.removeDuplicates()
                for tmp in unique{
                    let tmpdate = dateFormatter.date(from: tmp)
                    let datesAreInTheSameMonth = calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[1].date, toGranularity:.month)
                    if (datesAreInTheSameMonth == true){
                        if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[1].date, toGranularity:.weekOfYear)){
                            count[0] += 1
                        }
                        else if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[8].date, toGranularity:.weekOfYear)){
                            count[1] += 1
                        }
                        else if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[15].date, toGranularity:.weekOfYear)){
                            count[2] += 1
                        }
                        else if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[22].date, toGranularity:.weekOfYear)){
                            count[3] += 1
                        }
                        else if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[29].date, toGranularity:.weekOfYear)){
                            count[4] += 1
                        }
                        else if (calendar.isDate(tmpdate!, equalTo: self.calendarView.visibleDates().monthDates[32].date, toGranularity:.weekOfYear)){
                            count[5] += 1
                        }
                    }
                }
                
                var dataEntries = [BarChartDataEntry]()
                for index in 0...count.count - 1{
                    let tmp = BarChartDataEntry(x: Double(index) + 1.0, y:Double(count[index]))
                    dataEntries.append(tmp)
                }
                
                let chartDataSet = BarChartDataSet(values: dataEntries, label: nil)
                chartDataSet.setColor(UIColor(red: 86/255, green: 192/255, blue: 224/255, alpha: 1.0))
                let chartData = BarChartData(dataSet: chartDataSet)
                chartData.setDrawValues(false)
                chartData.barWidth = 0.3
                
                
                self.chartView.data = chartData
            }
        }
        
        //        lineView.delegate = self
        //        lineView.animate(yAxisDuration: 2.5, easingOption: .easeOutCubic)
        //        lineView.chartDescription?.enabled = false
        //        lineView.pinchZoomEnabled = false
        //        lineView.dragEnabled = false
        //        lineView.highlightPerTapEnabled = false
        //        lineView.doubleTapToZoomEnabled = false
        //        lineView.leftAxis.drawGridLinesEnabled = false
        //        lineView.rightAxis.enabled = false
        //        lineView.leftAxis.enabled = true
        //        lineView.xAxis.enabled = false
        //        lineView.legend.enabled = false
        //        lineView.leftAxis.axisLineColor = UIColor.white
        //        lineView.leftAxis.labelTextColor = UIColor.white
        //
        //        var dataEntries = [ChartDataEntry]()
        //        let tmp = ChartDataEntry(x: 1.0, y: 25.0)
        //        dataEntries.append(tmp)
        //        let tmp2 = ChartDataEntry(x: 2.0, y: 10.0)
        //        dataEntries.append(tmp2)
        //        let tmp3 = ChartDataEntry(x: 3.0, y: 15.0)
        //        dataEntries.append(tmp3)
        //        let tmp4 = ChartDataEntry(x: 4.0, y: 2.0)
        //        dataEntries.append(tmp4)
        //
        //        let chartDataSet = LineChartDataSet(values: dataEntries, label: nil)
        //        chartDataSet.cubicIntensity = 0.2
        //        chartDataSet.mode = .cubicBezier
        //
        //        let chartData = LineChartData(dataSet: chartDataSet)
        //        chartData.setDrawValues(false)
        //        lineView.data = chartData
    }
    
    func parseDate(){
        ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exos").observeSingleEvent(of: .value, with: { (snap) in
            if !snap.exists() { return }
            
            var keys = [String]()
            let tmp = snap.value as! [String:Any]
            for child in tmp{
                keys.append(child.key)
            }
            
            for index in 0...keys.count - 1{
                if let row = tmp[keys[index]] as? [String:String]{
                    self.allDate.append(row["date"]!)
                }
            }
            var tabDate = [Date]()
            for tmp in self.allDate{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                let tmpdate = dateFormatter.date(from: tmp)
                tabDate.append(tmpdate!)
            }
            self.calendarView.reloadDates(tabDate)
            self.updateChartWithData()
        })
    }
    
    func displayMonthYear(visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
            if let dest = segue.destination as? FormsViewController{
                dest.date = selectedDate
                self.isAdding = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSelected.count
    }
    
    func parseSelected(_ selectedDate: Date){
        DispatchQueue.init(label: "queue3").async {
            self.listSelected.removeAll()
            self.ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exos").observeSingleEvent(of: .value, with: { (snap) in
                if !snap.exists() { return }
                
                var keys = [String]()
                let tmp = snap.value as! [String:Any]
                for child in tmp{
                    keys.append(child.key)
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                let tmpdateString = dateFormatter.string(from: selectedDate)
                
                var saveKeys = [String]()
                for index in 0...keys.count - 1{
                    if let row = tmp[keys[index]] as? [String:String]{
                        if (row["date"] == tmpdateString){
                            saveKeys.append(keys[index])
                        }
                    }
                }
                if (saveKeys.count > 0){
                    for index in 0...saveKeys.count - 1{
                        self.listSelected[index] = tmp[saveKeys[index]]
                    }
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListHomeTableViewCell else {
            fatalError("unexpected IndePath")
        }
        if (indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.black
        }
        
        let element = listSelected[indexPath.row] as? [String:Any]

        cell.exoName.text = element?["name"] as? String
        if (indexPath.row == 0){
            cell.date.text = element?["date"] as? String
        }else{
            cell.date.text = ""
        }
        cell.rep.text = String(format:"Rep: \(element?["rep"] ?? "")")
        cell.serie.text = String(format:"Serie: \(element?["serie"] ?? "")")
        cell.kg.text = String(format:"\(element?["KG"] ?? "") KG")
        return cell
    }
}

extension HomeViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from:"2017 01 01")
        let endDate = formatter.date(from: "2030 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!, numberOfRows: nil, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: .monday, hasStrictBoundaries: nil)
        return parameters
    }
}

extension HomeViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dataLabel.text  = cellState.text
        
        let today = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 2*60*60)!
        let datesAreInTheSameMonth = calendar.isDate(today, equalTo: cellState.date, toGranularity:.month)
        
        
        if (datesAreInTheSameMonth == true){
            formatter.dateFormat = "dd"
            var str = formatter.string(from: today)
            if (str.characters.first == "0"){
                str.remove(at: str.startIndex)
            }
            if (str == cellState.text){
                cell.isToday.isHidden = false
                self.hadFindToday = true
            }
            else{
                cell.isToday.isHidden = true
            }
        }
        else{
            cell.isToday.isHidden = true
        }
        
        cell.selectedView.isHidden = true
        self.selectedDate = Date()
        for tmp in allDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy MM dd"
            let tmpdate = dateFormatter.date(from: tmp)
            if (tmpdate?.compare(date) == .orderedSame){
                cell.hasExercice.isHidden = false
                break
            }
            else{
                cell.hasExercice.isHidden = true
            }
        }
        
        if (cellState.dateBelongsTo != .thisMonth){
            cell.isHidden = true
        }
        else{
            cell.isHidden = false
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCollectionViewCell else {return}
        validCell.selectedView.isHidden = false
        selectedDate = date
        parseSelected(date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCollectionViewCell else {return}
        validCell.selectedView.isHidden = true
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.displayMonthYear(visibleDates: visibleDates)
        counteur = Array(repeating: 0, count: 6)
        updateChartWithData()
    }
}

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
