//
//  RegisterViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 20/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var pseudo: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pseudo.attributedPlaceholder = NSAttributedString(string: pseudo.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        email.attributedPlaceholder = NSAttributedString(string: email.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: email.frame.size.height))
        email.leftView = padding
        email.leftViewMode = UITextFieldViewMode.always
        let padding1 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: password.frame.size.height))
        password.leftView = padding1
        password.leftViewMode = UITextFieldViewMode.always
        let padding2 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: pseudo.frame.size.height))
        pseudo.leftView = padding2
        pseudo.leftViewMode = UITextFieldViewMode.always
        pseudo.layer.cornerRadius = 21.0
        pseudo.layer.borderWidth = 0.0
        email.layer.cornerRadius = 21.0
        email.layer.borderWidth = 0.0
        password.layer.cornerRadius = 21.0
        password.layer.borderWidth = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    @IBAction func creationTapped(_ sender: Any) {
        if let tmpPseudo = pseudo.text, let tmpEmail = email.text, let tmpPassword = password.text{
            FIRAuth.auth()?.createUser(withEmail: tmpEmail, password: tmpPassword, completion: { (user, error) in
                if (error == nil){
                    self.ref.child("users").child((user?.uid)!).setValue(["pseudo":tmpPseudo])
                    let alert = UIAlertController(title: "Compte crée", message: "Votre compte à bien été crée", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                    
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                else{
                    let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true) { 
            
        }
    }
  
}
