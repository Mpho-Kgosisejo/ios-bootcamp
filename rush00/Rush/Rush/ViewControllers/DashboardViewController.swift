//
//  DashboardViewController.swift
//  Rush
//
//  Created by Mpho KGOSISEJO on 2018/10/07.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        self.title = UserData.dUserJSON.value(forKey: "displayname") as? String
        print("UserData: ", UserData.dUserJSON)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
