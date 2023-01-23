//
//  SignInViewController.swift
//  MyArea
//
//  Created by Vijay Rathore on 21/01/23.
//

import UIKit
import Firebase


fileprivate var currentNonce: String?
class SignInViewController : UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var forgotPassword: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var remeberCheck: UIButton!
    
    @IBOutlet weak var signUp: UILabel!
    
    
    override func viewDidLoad() {
        
        emailTF.layer.cornerRadius = 12
        emailTF.addBorder()
        emailTF.setLeftPaddingPoints(16)
        emailTF.setRightPaddingPoints(10)
        emailTF.setLeftView(image: UIImage(named: "mail")!)
        emailTF.delegate = self
        
        passwordTF.layer.cornerRadius = 12
     
        passwordTF.addBorder()
        passwordTF.setLeftPaddingPoints(16)
        passwordTF.setRightPaddingPoints(10)
        passwordTF.setLeftView(image: UIImage(named: "padlock")!)
        passwordTF.delegate = self
        
        loginBtn.layer.cornerRadius = 12
        
      
        
        //RESET PASSWORD
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(forgotPasswordClicked)))
        
        //RegisterNow
        signUp.isUserInteractionEnabled = true
        signUp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(registerBtnClicked)))
        
       
        
       
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hidekeyboard)))
        
        
        let rememberMeFlag = UserDefaults.standard.bool(forKey: "REMEMBER_USER")
        remeberCheck.isSelected = rememberMeFlag
        if rememberMeFlag {
            emailTF.text = UserDefaults.standard.string(forKey: "USER_EMAIL")
            passwordTF.text = UserDefaults.standard.string(forKey: "PASSWORD")
                
        }
    }
  
    
    @IBAction func remeberMeCheckClicked(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }
        else {
            sender.isSelected = true
        }
    }
    
    
    @objc func registerBtnClicked(){
        performSegue(withIdentifier: "signUpSeg", sender: nil)
    }
    
    @objc func forgotPasswordClicked() {
        let sEmail = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else {
            ProgressHUDShow(text: "")
            Auth.auth().sendPasswordReset(withEmail: sEmail!) { error in
                self.ProgressHUDHide()
                if error == nil {
                    self.showMessage(title: "RESET PASSWORD", message: "We have sent reset password link on your mail address.", shouldDismiss: false)
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
    }
    
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        
        let sEmail = emailTF.text?.trimmingCharacters(in: .nonBaseCharacters)
        let sPassword = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if sEmail == "" {
            showSnack(messages: "Enter Email Address")
        }
        else if sPassword == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "")
            Auth.auth().signIn(withEmail: sEmail!, password: sPassword!) { authResult, error in
                self.ProgressHUDHide()
                if error == nil {
                    if self.remeberCheck.isSelected {
                        UserDefaults.standard.set(true, forKey: "REMEMBER_USER")
                        UserDefaults.standard.set(sEmail, forKey:"USER_EMAIL")
                        UserDefaults.standard.set(sPassword, forKey:"PASSWORD")
                    }
                    else {
                        UserDefaults.standard.set(false, forKey: "REMEMBER_USER")
                        UserDefaults.standard.removeObject(forKey: "USER_EMAIL")
                        UserDefaults.standard.removeObject(forKey: "PASSWORD")
                    }
                    self.getUserData(uid: Auth.auth().currentUser!.uid, showProgress: true)
        
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
 
    }
    
    @objc func hidekeyboard(){
        view.endEditing(true)
    }
   

}

extension SignInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hidekeyboard()
        return true
    }
}

