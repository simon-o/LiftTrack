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

    @IBOutlet weak var appTitle: UILabel!
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
        email.layer.cornerRadius = 21.0
        email.layer.borderWidth = 0.0
        password.layer.cornerRadius = 21.0
        password.layer.borderWidth = 0.0
        
        //Debug
        email.text = "lol1@lol.fr"
        password.text = "lollol"
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let oldEmail = email.frame.origin
        let oldPassword = password.frame.origin
        let oldTitle = appTitle.frame.origin
        
        appTitle.alpha = 0
        email.alpha = 0
        password.alpha = 0
        
        email.frame.origin.x = -250
        appTitle.frame.origin.y = -30
        password.frame.origin.x = -250
        
        UIView.animate(withDuration: 1.2, animations: {
            self.appTitle.frame.origin = oldTitle
            self.appTitle.alpha = 1
        }) { (finished) in
            
        }
        UIView.animate(withDuration: 0.8, delay: 1.2, usingSpringWithDamping: 2.0, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
            self.email.frame.origin = oldEmail
            self.password.frame.origin = oldPassword
            self.email.alpha = 1
            self.password.alpha = 1
        }) { (finished) in
            
        }
    }
    
    @IBAction func connectTapped(_ sender: Any) {
        if let tmpEmail = email.text, let tmpPassword = password.text{
            FIRAuth.auth()?.signIn(withEmail: tmpEmail, password: tmpPassword, completion: { (user, error) in
                if (error != nil){
                    let alert = UIAlertController(title: "Erreur", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    UserDefaults.standard.set(user?.uid, forKey: "userUID")
                    if let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "MainTabBar")) as? UITabBarController
                    {
                        self.present(homeVC, animated: true, completion: {
                        })
                    }
                }
            })
        }
    }
}

