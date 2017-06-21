//
//  ViewController.swift
//  LiftTrack
//
//  Created by Antoine Simon on 20/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        email.attributedPlaceholder = NSAttributedString(string: email.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: password.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.white])
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: email.frame.size.height))
        email.leftView = padding
        email.leftViewMode = UITextFieldViewMode.always
        let padding1 = UIView(frame: CGRect(x: 0, y: 0, width: 20.0, height: password.frame.size.height))
        password.leftView = padding1
        password.leftViewMode = UITextFieldViewMode.always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectTapped(_ sender: Any) {
        if let tmpEmail = email.text, let tmpPassword = password.text{
            FIRAuth.auth()?.signIn(withEmail: tmpEmail, password: tmpPassword, completion: { (user, error) in
                if let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")) as? UITabBarController
                {
                    self.present(homeVC, animated: true, completion: {
                    })
                }
            })
        }
    }
}

