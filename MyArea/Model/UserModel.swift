//
//  UserModel.swift
//  MyArea
//
//  Created by Vijay Rathore on 22/01/23.
//

import UIKit

class UserModel : NSObject, Codable {
    
    var userName : String?
    var fullName : String?
    var email : String?
    var uid : String?
    var registredAt : Date?
    var notiToken : String?
    var profilePic : String?
    var gender : String?
    var dob : Date?
    private static var userData : UserModel?
   
    static var data : UserModel? {
        set(userData) {
            self.userData = userData
        }
        get {
            return userData
        }
    }


    override init() {
        
    }
    
}
