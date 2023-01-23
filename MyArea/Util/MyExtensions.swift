//
//  MyExtensions.swift
//  MyArea
//
//  Created by Vijay Rathore on 21/01/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase
import MBProgressHUD
import TTGSnackbar
import FirebaseFirestore
import AVFoundation

extension UIView {
    
    func addBorder() {
        layer.borderWidth = 0.8
        layer.borderColor = UIColor(red: 0/255, green: 157/255, blue: 239/255, alpha: 1).cgColor
    }
    
}

extension UITextField {
 
      func setLeftView(image: UIImage) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 10, width: 22, height: 22)) // set your Own size
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 45))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
      
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        
        self.rightView = paddingView
        self.rightViewMode = .always
        
    }
    
    func changePlaceholderColour()  {
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1)])
    }
    
   
    
    /// set icon of 20x20 with left padding of 8px
    func setLeftIcons(icon: UIImage) {
        
        let padding = 8
        let size = 20
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        leftView = outerView
        leftViewMode = .always
    }
    
    
    
    
    /// set icon of 20x20 with left padding of 8px
    func setRightIcons(icon: UIImage) {
        
        let padding = 8
        let size = 12
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size) )
        let iconView  = UIImageView(frame: CGRect(x: -padding, y: 0, width: size, height: size))
        iconView.image = icon
        outerView.addSubview(iconView)
        
        rightView = outerView
        rightViewMode = .always
    }
    
}








extension Date {
    
    
    func removeTimeStamp() -> Date? {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
            return  nil
        }
        return date
    }
    
    func timeAgoSinceDate() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
    }
}




extension UIViewController {

 
    
    func showSnack(messages : String) {
        
        
        let snackbar = TTGSnackbar(message: messages, duration: .long)
        snackbar.messageLabel.textAlignment = .center
        snackbar.show()
    }
    
    func ProgressHUDShow(text : String) {
        let loading = MBProgressHUD.showAdded(to: self.view, animated: true)
        loading.mode = .indeterminate
        loading.label.text =  text
        loading.label.font = UIFont(name: "Poppins-Medium", size: 11)
    }
    
    func ProgressHUDHide(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    

    

//    func sentVerificationEmail(){
//        self.ProgressHUDShow(text: "")
//        Auth.auth().currentUser!.sendEmailVerification { error in
//            self.ProgressHUDHide()
//            if error == nil {
//                self.showMessage(title: "Verify Your Email", message: "We have sent verification mail on your email address. Please verify your email address before Sign In.",shouldDismiss: true)
//            }
//            else {
//                self.showError(error!.localizedDescription)
//            }
//        }
//    }
//
    
    func addUserData(userData : UserModel) {
        
        ProgressHUDShow(text: "")
     
        
        try?  Firestore.firestore().collection("Users").document(userData.uid ?? "123").setData(from: userData,completion: { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error != nil {
                self.showError(error!.localizedDescription)
            }
            else {
                self.getUserData(uid: userData.uid ?? "123", showProgress: true)
              
            }
           
        })
                                                                                                                                  
           
    }
    
    func membershipDaysLeft(currentDate : Date, expireDate : Date) -> Int {
        
        
        
        return Calendar.current.dateComponents([.day], from: currentDate, to: expireDate).day ?? 0
        
        
    }
    
    
    func checkMembershipStatus(currentDate : Date, expireDate : Date) -> Bool{
        
   if currentDate < expireDate  {
            
            return true
            
        }
        return false
    }
    

    
    func getUserData(uid : String, showProgress : Bool)  {
        

        
        if showProgress {
            ProgressHUDShow(text: "")
        }
        
        Firestore.firestore().collection("Users").document(uid).getDocument { (snapshot, error) in
            
            
            if error != nil {
                if showProgress {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
                self.showError(error!.localizedDescription)
            }
            else {
                
                if let snapshot = snapshot, snapshot.exists {
                        
    
                        if let user = try? snapshot.data(as: UserModel.self) {
                            UserModel.data = user
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                            
                           
                          
                       
                        }
                        
                   
                    
                }
                else {
                    DispatchQueue.main.async {
                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                    }
                    
                }
                
                
                
                
            }
        }
    }
    




func navigateToAnotherScreen(mIdentifier : String)  {
    
    let destinationVC = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
    destinationVC.modalPresentationStyle = .fullScreen
    present(destinationVC, animated: true) {
        
    }
}

func myPerformSegue(mIdentifier : String)  {
    performSegue(withIdentifier: mIdentifier, sender: nil)
    
}

func getViewControllerUsingIdentifier(mIdentifier : String) -> UIViewController{
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)

    switch mIdentifier {
    case Constants.StroyBoard.signInViewController:
        return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? SignInViewController)!
        
    case Constants.StroyBoard.tabBarViewController :
        return (mainStoryboard.instantiateViewController(identifier: mIdentifier) as? UITabBarController )!
        

  

    default:
        return (mainStoryboard.instantiateViewController(identifier: Constants.StroyBoard.signInViewController) as? SignInViewController)!
    }
}

func beRootScreen(mIdentifier : String) {
    
    guard let window = self.view.window else {
        self.view.window?.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
        self.view.window?.makeKeyAndVisible()
        return
    }
    
    window.rootViewController = getViewControllerUsingIdentifier(mIdentifier: mIdentifier)
   
}
    
    func convertSecondstoMinAndSec(totalSeconds : Int) -> String{
     
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        return String(format: "%02i : %02i", minutes, seconds)

    }

func convertDateToMonthFormater(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "MMMM"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}


func convertDateAndTimeFormater(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "dd-MMM-yyyy hh:mm a"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

func convertDateFormaterWithoutDash(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "dd MMM yyyy"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

func convertDateFormater(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "dd-MMM-yyyy"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

func convertDateFormaterWithSlash(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "dd/MM/yy"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

func convertDateForHomePage(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "EEEE, dd MMMM"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}
func convertDateForVoucher(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "E, MMM dd  yyyy • hh:mm a"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}
    

    
func convertDateForTicket(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "E,MMM dd, yyyy hh:mm a"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

    func dayDifference(from date : Date) -> String
    {
        let calendar = Calendar.current
        
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(-day) days ago" }
            else { return "In \(day) days" }
        }
    }

func convertDateIntoTimeForRecurringVoucher(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "hh:mm a"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return "\(df.string(from: date))"
    
    
}



func convertDateIntoMonthAndYearForRecurringVoucher(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "MMM • yyyy"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return "\(df.string(from: date))"
    
}

func convertDateIntoDayForRecurringVoucher(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "EEEE"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return "\(df.string(from: date))"
    
}

func convertDateIntoDayDigitForRecurringVoucher(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "d"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return "\(df.string(from: date))"
    
}

func convertDateForShowTicket(_ date: Date, endDate :Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "E,dd"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    let s = "\(df.string(from: date))-\(df.string(from: endDate))"
    df.dateFormat = "MMM yyyy"
    return "\(s) \(df.string(from: date))"
}

func convertTimeFormater(_ date: Date) -> String
{
    let df = DateFormatter()
    df.dateFormat = "hh:mm a"
    df.timeZone = TimeZone(abbreviation: "UTC")
    df.timeZone = TimeZone.current
    return df.string(from: date)
    
}

   
func showError(_ message : String) {
    let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
    
    alert.addAction(okAction)
    
    self.present(alert, animated: true, completion: nil)
    
}

func showMessage(title : String,message : String, shouldDismiss : Bool = false) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Ok",style: .default) { action in
        if shouldDismiss {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
    
}




public func logout(){
    do {
        try Auth.auth().signOut()
        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
    }
    catch {
        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
    }
}

}






extension UIImageView {
    func makeRounded() {
        
        //self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        // self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
    }
    
    
    
    
}



extension UIView {
    
    func smoothShadow(){
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 1.8)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
   
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
    
        layer.mask = mask

    }
}


extension Date {
    public func setTime(hour: Int, min: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        
        return cal.date(from: components)
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}


