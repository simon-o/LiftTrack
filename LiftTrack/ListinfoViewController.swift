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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
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
        ref.child("users").child(UserDefaults.standard.string(forKey: "userUID")!).child("exos").observeSingleEvent(of: .value, with: { (snap) in
            if !snap.exists() { return }
            
            var keys = [String]()
            let tmp = snap.value as! [String:Any]
            for child in tmp{
                keys.append(child.key)
            }
            
            for index in 0...keys.count - 1{
                if let row = tmp[keys[index]] as? [String:[Any]]{
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
        return 2
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "test"
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
