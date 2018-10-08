//
//  responseController.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/07.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit

class responseController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "responseCell") as! responseCell
        cell.author.text = Responses[indexPath.row].user
        cell.date.text = Responses[indexPath.row].date
        cell.message.text = Responses[indexPath.row].content
        return cell
    }
    

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Responses.removeAll()
        UserData.api.getReponses(topicID: TopicID, messageID: MessageID)

        // Do any additional setup after loading the view.
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
