/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    var signUpMode = true
    var activityIndicatior = UIActivityIndicatorView ()
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var changeSignUpMode: UIButton!
    @IBOutlet var signupOrLogin: UIButton!
    
    func createAlert(title:String,message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    
    
    @IBAction func signUpOrLogin(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == ""{
            createAlert(title: "Sorry!", message: "Enter both Email and Password")
        }
        else{
            
            activityIndicatior = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicatior.center = self.view.center
            activityIndicatior.hidesWhenStopped = true
            activityIndicatior.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicatior)
            activityIndicatior.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode{
                
                
                //sign up
                let user = PFUser()
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    self.activityIndicatior.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil{
                        
                        var displayErrorMessage = "Please try again later"
                        
                        if let errorMessage = error?.localizedDescription{
                            
                        displayErrorMessage = errorMessage
                        self.createAlert(title: "Sorry!", message: displayErrorMessage)
                            
                        }
                    }else{
                        print("user Signed up")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                    
                })
                
            }else{
                //login Mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicatior.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if error != nil{
                        var displayErrorMessage = "Please try again later"
                        
                        if let errorMessage = error?.localizedDescription{
                            
                            displayErrorMessage = errorMessage
                            self.createAlert(title: "Sorry!", message: displayErrorMessage)
                        }
                    }else{
                        print("User logged in")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
            }
        }
    }

    @IBAction func chamgeSignUpMode(_ sender: Any) {
        if signUpMode{
            
            //change to login mode
            
            signupOrLogin.setTitle("Log In", for: [])
            changeSignUpMode.setTitle("Sign Up", for: [])
            messageLabel.text = "Don't have an account?"
            signUpMode = false
        }else{
            //change to signUp mode
            signupOrLogin.setTitle("Sign Up", for: [])
            changeSignUpMode.setTitle("Log In", for: [])
            messageLabel.text = "Already have an account?"
            signUpMode = true
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
