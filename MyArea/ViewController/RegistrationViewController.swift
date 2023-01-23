//
//  RegistrationViewController.swift
//  MyArea
//
//  Created by Vijay Rathore on 22/01/23.
//

import UIKit
import Firebase
import CropViewController

class RegistrationViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var fullnameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var dobTF: UITextField!
    
    @IBOutlet weak var maleCheck: UIButton!
    
    @IBOutlet weak var femaleCheck: UIButton!
    
    var gender : String = ""
    
    var isImageSelected = false
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        
        profilePic.layer.cornerRadius = 12
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
        
        usernameTF.setLeftPaddingPoints(16)
        usernameTF.setRightPaddingPoints(10)
        usernameTF.setLeftView(image: UIImage(named: "avatar")!)
        usernameTF.delegate = self
        usernameTF.layer.cornerRadius = 12
        usernameTF.addBorder()
        
        fullnameTF.setLeftPaddingPoints(16)
        fullnameTF.setRightPaddingPoints(10)
        fullnameTF.setLeftView(image: UIImage(named: "avatar")!)
        fullnameTF.delegate = self
        fullnameTF.addBorder()
        fullnameTF.layer.cornerRadius = 12
        
        
        emailTF.setLeftPaddingPoints(16)
        emailTF.setRightPaddingPoints(10)
        emailTF.setLeftView(image: UIImage(named: "mail")!)
        emailTF.delegate = self
        emailTF.addBorder()
        emailTF.layer.cornerRadius = 12
        
        passwordTF.setLeftPaddingPoints(16)
        passwordTF.setRightPaddingPoints(10)
        passwordTF.setLeftView(image: UIImage(named: "padlock")!)
        passwordTF.delegate = self
        passwordTF.addBorder()
        passwordTF.layer.cornerRadius = 12
        
        
        dobTF.setLeftPaddingPoints(10)
        dobTF.setRightPaddingPoints(16)
        dobTF.setLeftView(image: UIImage(named: "calendar")!)
        dobTF.delegate = self
        dobTF.addBorder()
        dobTF.layer.cornerRadius = 12
        
        registerBtn.layer.cornerRadius = 12
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 12
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        createDatePicker()
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    func createDatePicker() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDoneBtnTapped))
        toolbar.setItems([done], animated: true)
        
        dobTF.inputAccessoryView = toolbar
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        dobTF.inputView = datePicker
    }
    
    @objc func startDateDoneBtnTapped() {
        view.endEditing(true)
        let date = datePicker.date
        dobTF.text = self.convertDateFormater(date)
        
        
    }
    
    @IBAction func maleCheckClicked(_ sender: UIButton) {
        maleCheck.isSelected = true
        femaleCheck.isSelected = false
        gender = "male"
    }
    
    
    @IBAction func femaleCheckClicked(_ sender: Any) {
        femaleCheck.isSelected = true
        maleCheck.isSelected = false
        gender = "female"
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        let sUsername = usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sFullName = fullnameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmail = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sDob = dobTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !isImageSelected {
            self.showSnack(messages: "Upload Profile Picture")
        }
        else if sUsername == "" {
            showSnack(messages: "Enter Username")
        }
        else if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword  == "" {
            showSnack(messages: "Enter Password")
        }
        else if sDob == "" {
            showSnack(messages: "Select Date Of Birth")
        }
        else if gender == "" {
            showSnack(messages: "Select Gender")
        }
        else {
            
            
            ProgressHUDShow(text: "Creating Account...")
            
            Firestore.firestore().collection("Users").whereField("userName", isEqualTo: sUsername!).getDocuments { snapshot, error in
                if let error = error {
                    self.ProgressHUDHide()
                    self.showError(error.localizedDescription)
                }
                else {
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        self.ProgressHUDHide()
                        self.showMessage(title: "Not available", message: "Username \(sUsername!) is already in use.", shouldDismiss: false)
                    }
                    else {
                        Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                            self.ProgressHUDHide()
                            if error == nil {
                                let userData = UserModel()
                                userData.userName = sUsername
                                userData.fullName = sFullName
                                userData.email = sEmail
                                userData.uid = Auth.auth().currentUser!.uid
                                userData.registredAt = Date()
                                userData.gender = self.gender
                                userData.dob = self.datePicker.date
                                
                                self.ProgressHUDShow(text: "")
                               
                                self.uploadImageOnFirebase(uid: Auth.auth().currentUser!.uid) { downloadURL in
                                    self.ProgressHUDHide()
                                    if !downloadURL.isEmpty {
                                        userData.profilePic = downloadURL
                                        self.addUserData(userData: userData)
                                    }
                                    
                                }
                            
                            }
                            else {
                                self.showError(error!.localizedDescription)
                            }
                        }
                    }
                }
            }
            
           
        }
    }
    
    @objc func imageViewClicked(){
        chooseImageFromPhotoLibrary()
    }
    
    func chooseImageFromPhotoLibrary(){
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        self.present(image,animated: true)
    }
    
}

extension RegistrationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}

extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1  , height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
            isImageSelected = true
            profilePic.image = image
            self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(uid : String,completion : @escaping (String) -> Void ) {
        
        let storage = Storage.storage().reference().child("ProfilePicture").child(uid).child("\(uid).png")
        var downloadUrl = ""
        
        var uploadData : Data!
        uploadData = (self.profilePic.image?.jpegData(compressionQuality: 0.5))!
        
    
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
}
