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
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
       formatter.dateFormat = "yyy MM dd"

        let startDate = formatter.date(from:"2017 01 01")
        let endDate = formatter.date(from: "2030 12 31")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dataLabel.text  = cellState.text
        return cell
    }
}
