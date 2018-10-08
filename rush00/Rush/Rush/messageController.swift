//
//  messageController.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/07.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit

class messageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell") as! messageCell
        cell.author.text = Messages[indexPath.row].user
        cell.date.text = Messages[indexPath.row].date
        cell.message.text = Messages[indexPath.row].content
        return cell
        
    }
    

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Messages.removeAll()
        UserData.api.getMessages(id: TopicID)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Messages.removeAll()
        UserData.api.getMessages(id: TopicID)
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "responseController")
        let page = newViewController as! responseController
        MessageID = Messages[indexPath.row].id
        self.navigationController?.pushViewController(page, animated: true)
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
