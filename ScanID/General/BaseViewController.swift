//
//  BaseViewController.swift
//  ScanID
//
//  Created by Ashley Han on 26/08/17.
//  Copyright © 2017 simpletask. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyNavigationBarConfigs()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func applyNavigationBarConfigs() {
        guard let navigationController = self.navigationController else {
            return
        }
      
        // Shadown Image
        if showShadowImage() {
            navigationController.navigationBar.shadowImage = nil
        } else {
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        }
        
        // Navigation Background Image
        if navigationBarBgImage() != nil {
            navigationController.navigationBar.setBackgroundImage(navigationBarBgImage(), for: .default)
        } else {
            navigationController.navigationBar.setBackgroundImage(nil, for: .default)
        }
    }
    
    func navigationBarBgImage() -> UIImage? {
        return nil
    }
    
    func showShadowImage() -> Bool {
        return false
    }
    
    func hideBottomBarWhenPushed() -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
