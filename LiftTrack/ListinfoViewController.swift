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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add"{
            if let dest = segue.destination as? FormsViewController{
                dest.date = Date()
            }
        }
    }
    
    func parseDate(){
        ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exosList").observeSingleEvent(of: .value, with: { (snap) in
            if !snap.exists() { return }
            
            
            let tmp = snap.value as! [String:[String:[String:String]]]
            for child in tmp{
                self.keysName.append(child.key)
                
                let rows = child.value
                for index in rows{
                    if (self.finalDict[child.key] == nil){
                        self.finalDict[child.key] = [String]()
                    }
                    self.finalDict[child.key]?.append(rows[index.key]?["KG"] ?? "")
                }
            }

            self.tableView.reloadData()
            
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finalDict[keysName[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keysName[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0){
             let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ListGrpahTableViewCell
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ListInfoTableViewCell
            
            return cell
        }
    }
}
