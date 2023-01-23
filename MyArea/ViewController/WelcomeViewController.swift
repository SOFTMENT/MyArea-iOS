//
//  ViewController.swift
//  MyArea
//
//  Created by Vijay Rathore on 21/01/23.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class WelcomeViewController :  UIViewController {
   
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        //SUBSCRIBE TO TOPIC
        Messaging.messaging().subscribe(toTopic: "myarea"){ error in
            if error == nil{
                print("Subscribed to topic")
            }
            else{
                print("Not Subscribed to topic")
            }
        }
        
        
        if userDefaults.value(forKey: "appFirstTimeOpend") == nil {
            //if app is first time opened then it will be nil
            userDefaults.setValue(true, forKey: "appFirstTimeOpend")
            // signOut from FIRAuth
            do {
                try Auth.auth().signOut()
            }catch {

            }
            // go to beginning of app
        }
        

            
            if Auth.auth().currentUser != nil {
                
                self.getUserData(uid: Auth.auth().currentUser!.uid, showProgress: false)
                
                
            }
            else {
                
                self.gotoSignInViewController()

                
            }
            
            
        
               
    }
    
    func gotoSignInViewController(){
        DispatchQueue.main.async {
            self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
        }
    }
    
}
