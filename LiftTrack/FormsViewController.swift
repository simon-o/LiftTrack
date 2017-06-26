//
//  FormsViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 24/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit

class FormsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var exoName: UITextField!
    @IBOutlet weak var exoRep: UITextField!
    @IBOutlet weak var exoSerie: UITextField!
    @IBOutlet weak var exoKG: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        exoName.attributedPlaceholder = NSAttributedString(string: exoName.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoRep.attributedPlaceholder = NSAttributedString(string: exoRep.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoSerie.attributedPlaceholder = NSAttributedString(string: exoSerie.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        exoKG.attributedPlaceholder = NSAttributedString(string: exoKG.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoName.frame.size.height))
        exoName.leftView = padding
        exoName.leftViewMode = UITextFieldViewMode.always
        let padding2 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoRep.frame.size.height))
        exoRep.leftView = padding2
        exoRep.leftViewMode = UITextFieldViewMode.always
        let padding3 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoSerie.frame.size.height))
        exoSerie.leftView = padding3
        exoSerie.leftViewMode = UITextFieldViewMode.always
        let padding4 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: exoKG.frame.size.height))
        exoKG.leftView = padding4
        exoKG.leftViewMode = UITextFieldViewMode.always
        
        exoName.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func test(){
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let picker = PickerDialog()
        
        picker.show(title: "test", options: [["value":"l"],["value":"p"],["value":"g"]]) { (response) in
          print(response)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
    }
}
