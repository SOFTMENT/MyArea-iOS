//
//  TabBarViewController.swift
//  MyArea
//
//  Created by Vijay Rathore on 22/01/23.
//


import UIKit

class TabBarViewController : UITabBarController, UITabBarControllerDelegate {
    
    var tabBarItems = UITabBarItem()
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self

        
        let selectedImage1 = UIImage(named: "category")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "category-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "group")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "group-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "bubble-chat")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "bubble-chat-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3


        
        let selectedImage4 = UIImage(named: "avatar 1")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage4 = UIImage(named: "avatar-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deSelectedImage4
        tabBarItems.selectedImage = selectedImage4
        
        

        
        
        selectedIndex = 0
        

    }
    
}

