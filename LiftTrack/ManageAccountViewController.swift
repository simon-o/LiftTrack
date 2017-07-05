//
//  ManageAccountViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 30/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import Firebase

class ManageAccountViewController: UIViewController {

    @IBOutlet weak var pass: UITextField!
    
    var user: FIRUser! = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        user = FIRAuth.auth()?.currentUser
        
        pass.attributedPlaceholder = NSAttributedString(string: pass.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: pass.frame.size.height))
        pass.leftView = padding
        pass.leftViewMode = UITextFieldViewMode.always
        pass.layer.cornerRadius = 21.0
        pass.layer.borderWidth = 0.0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changePassTapped(_ sender: Any) {
        pass.resignFirstResponder()
        user.updatePassword(pass.text ?? "") { (error) in
            if ((error) != nil){
                let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Mise à jour", message: "Mot de passe mit à jour.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func decoTapped(_ sender: Any) {
        let auth = FIRAuth.auth()
        do{
            try auth?.signOut()
            self.dismiss(animated: true, completion: { 
                
            })
        }catch _{
            let alert = UIAlertController(title: "Erreur", message: "Veuillez resseayer", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
