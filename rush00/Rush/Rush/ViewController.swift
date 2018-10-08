//
//  ViewController.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/06.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit

var TopicID = 0
var MessageID = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as! topicCell
        cell.author.text = Topics[indexPath.row].date
        cell.topic.text = Topics[indexPath.row].name
        cell.message.text = Topics[indexPath.row].user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newViewController = storyboard?.instantiateViewController(withIdentifier: "messageController")
        let page = newViewController as! messageController
        TopicID = Topics[indexPath.row].id
        self.navigationController?.pushViewController(page, animated: true)
    }
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Topics.removeAll()
        UserData.api.getTopics()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Topics.removeAll()
        UserData.api.getTopics()
        table.reloadData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(false)
//        self.navigationController?.popViewController(animated: false)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

