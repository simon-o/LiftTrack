//
//  HomeViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 20/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import JTAppleCalendar

class HomeViewController: UIViewController {
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarView.visibleDates { (visibleDates) in
            self.displayMonthYear(visibleDates: visibleDates)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let today = Date()
        calendarView?.scrollToDate(today)
    }
    
    func displayMonthYear(visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
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
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let datesAreInTheSameMonth = calendar.isDate(today, equalTo: cellState.date, toGranularity:.month)
        
        
        if (datesAreInTheSameMonth == true){
            formatter.dateFormat = "dd"
            let str = formatter.string(from: today)
            if (str == cellState.text){
                cell.isToday.isHidden = false
            }
            else{
                cell.isToday.isHidden = true
            }
        }
        else{
            cell.isToday.isHidden = true
        }
        
        if (cellState.isSelected){
            cell.selectedView.isHidden = false
        }else{
            cell.selectedView.isHidden = true
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
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCollectionViewCell else {return}
        validCell.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.displayMonthYear(visibleDates: visibleDates)
    }
}
