//
//  ListinfoViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 10/07/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import Firebase

class ListinfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var ref = FIRDatabase.database().reference()
    var keysName = [String]()
    var finalDict = [String:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        parseDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
            if let dest = segue.destination as? FormsViewController{
                dest.date = Date()
            }
        }
    }
    
    func parseDate(){
        ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exosList").observeSingleEvent(of: .value, with: { (snap) in
            self.finalDict = [String:[String]]()
            self.keysName = [String]()
            
            if !snap.exists() { return }
            
            let tmp = snap.value as! [String:[String:[String:String]]]
            for child in tmp{
                self.keysName.append(child.key)
                
                let rows = child.value
                let sorted = rows.sorted(by: { (value1, value2) -> Bool in
                    if (value1.value["date"]! > value2.value["date"]!){
                        return true
                    }
                    else{
                        return false
                    }
                })
                for index in sorted{
                    if (self.finalDict[child.key] == nil){
                        self.finalDict[child.key] = [String]()
                    }
                    self.finalDict[child.key]?.append(rows[index.key]?["KG"] ?? "")
                }
                self.finalDict[child.key]?.reverse()
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView{
            headerTitle.textLabel?.textColor = UIColor.white
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysName[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ListGrpahTableViewCell
        cell.selectionStyle = .none
        if let tmpArray = finalDict[keysName[indexPath.section]]{
            cell.updateChart(tmpArray)
        }
        return cell
    }
}

