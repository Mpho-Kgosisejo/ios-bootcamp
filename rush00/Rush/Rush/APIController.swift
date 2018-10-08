//
//  APIController.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/06.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import Foundation


struct Topic {
    
    var name: String;
    var user: String;
    var date: String;
    var messages_url: String!
    var id: Int!
    
    init(name: String, user: String, date: String, messages_url: String, id: Int) {
        self.name = name;
        self.user = user;
        self.date = date;
        self.messages_url = messages_url;
        self.id = id;
    }
}

struct Message {
    var content: String;
    var user: String;
    var date: String;
    var isReply: Bool;
    var id: Int!
    
    init(content: String, user: String, date: String, isReply: Bool, id: Int) {
        self.content = content;
        self.user = user;
        self.date = date;
        self.isReply = isReply;
        self.id = id;
    }
}

class UserData: Any {
    static var rawJSON: Data!
    static var dUserJSON: NSDictionary!
    static var api = APIController()
}

var Topics: [Topic] = [];
var Messages: [Message] = [];
var Responses: [Message] = [];

var Code = ""

class APIController
{
    let uid = "9dcd6588365173aa3cbdbb820e12e72b82434afe65f7208afbf2a14692d020c8"
    let secret = "fedf0a2f62aee1b77f70100da3c71d10ce0ace3fcbb7283ffa4ebd1396f0bb9d"
    static var TOKEN: String  = ""
    var id = 0
    var code = ""
    var endPoint: String = "https://api.intra.42.fr/v2"
    
    init() {
        
    }
    
    static func isAuth() -> Bool {
        //is user logged in...
        return (APIController.TOKEN.count > 0)
    }
    func resetState()
    {
        APIController.TOKEN = ""
        Code = ""
    }
    
    func getCodeRequest(code: String) -> NSMutableURLRequest {
        var grant = ""
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        let request :NSMutableURLRequest = NSMutableURLRequest(url: url!)
        
        grant = "grant_type=authorization_code"
        grant += "&code=\(code)"
        grant += "&redirect_uri=https://mpho-kgosisejo.github.io/portfolio/deeplinks/rush00iSOApp.html"
        grant += "&client_id=\(uid)"
        grant += "&client_secret=\(secret)"
        request.httpMethod = "POST"
        request.httpBody = grant.data(using: String.Encoding.utf8)
        return(request)
    }
    
    func setToken(code: String, with function: @escaping () -> ()) {
        print("Request token...")
        let task = URLSession.shared.dataTask(with: self.getCodeRequest(code: code) as URLRequest){
            (data, response, error) in
            // print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                        APIController.TOKEN = dic.value(forKey: "access_token") as! String
//                        if let temp = dic["access_token"]
//                        {
//                            APIController.TOKEN = temp as! String
//                        }
                        
                        print("Data: ", dic)
                        print("Token: " + APIController.TOKEN)
                        
                        DispatchQueue.main.async {
                            function()
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func GET_REDIRECT_URI() -> String {
        return ("https://api.intra.42.fr/oauth/authorize?client_id=\(uid)&redirect_uri=https%3A%2F%2Fmpho-kgosisejo.github.io%2Fportfolio%2Fdeeplinks%2Frush00iSOApp.html&response_type=code")
    }
    
    func handleDate(created_at: String) -> String {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX";
        let date = dateFormatter.date(from: created_at);
        dateFormatter.dateFormat = "MM/dd/yy HH:mm";
        if let d = date {
            return (dateFormatter.string(from: d));
        }
        return (created_at);
    }
    
    func handleTopics(dic: [Any]) {
        Topics.removeAll();
        for i in 0...(dic.count - 1) {
            if let topic = dic[i] as? [String: Any] {
                if let user = topic["author"] as? [String: Any] {
                    Topics.append(Topic(
                        name: topic["name"] as! String,
                        user: user["login"] as! String,
                        date: handleDate(created_at: topic["created_at"] as! String),
                        messages_url: topic["messages_url"] as! String,
                        id: topic["id"] as! Int
                    ));
                }
            }
        }
    }
    
    func handleMessages(dic: [Any], isReply: Bool) {
        
        for i in 0...(dic.count - 1) {
            if let message = dic[i] as? [String: Any] {
                if let user = message["author"] as? [String: Any] {
                    Messages.append(Message(
                        content: message["content"] as! String,
                        user: user["login"] as! String,
                        date: handleDate(created_at: message["created_at"] as! String),
                        isReply: isReply,
                        id: message["id"] as! Int
                        )
                    );
                };
            }
        }
    }
    
    func handleReponses(dic: [Any], isReply: Bool) {
        
        for i in 0...(dic.count - 1) {
            if let message = dic[i] as? [String: Any] {
                if let user = message["author"] as? [String: Any] {
                    Responses.append(Message(
                        content: message["content"] as! String,
                        user: user["login"] as! String,
                        date: handleDate(created_at: message["created_at"] as! String),
                        isReply: isReply,
                        id: message["id"] as! Int
                        )
                    );
                };
            }
        }
    }
    
    func getGetRequest(strUrl: String) -> NSMutableURLRequest{
        let url = URL(string: strUrl)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIController.TOKEN)", forHTTPHeaderField: "Authorization")
        
        return (request)
    }
    
    func getUserInfo(with function: @escaping () -> ()) {
        let task = URLSession.shared.dataTask(with: self.getGetRequest(strUrl: "\(self.endPoint)/me") as URLRequest){
            (data, response, error) in
            // print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                        
                        UserData.rawJSON = d
                        UserData.dUserJSON = dic
                        
                        DispatchQueue.main.async {
                            function()
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func connect()
    {
        let url = URL(string: "https://api.intra.42.fr/v2/oauth/token")

        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials&client_id=\(uid)&client_secret=\(secret)".data(using: String.Encoding.utf8)
        let group = DispatchGroup();
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                        if let temp = dic["access_token"]
                        {
                            APIController.TOKEN = temp as! String
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
            group.leave()
        }
        group.enter()
        task.resume()
        group.wait()
    }
    
    func getTopics()
    {
        let url = URL(string: "https://api.intra.42.fr/v2/topics.json")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIController.TOKEN)", forHTTPHeaderField: "Authorization")
        let group = DispatchGroup();
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic  = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any]{
                        if dic.count > 0
                        {
                            self.handleTopics(dic: dic)
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
            group.leave()
        }
        group.enter()
        task.resume()
        group.wait()
        print(Topics.count)
        
    }
    
    func getMessages(id : Int)
    {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(id)/messages")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIController.TOKEN)", forHTTPHeaderField: "Authorization")

        let group = DispatchGroup();
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any]{
                        if dic.count > 0
                        {
                            self.handleMessages(dic: dic, isReply: false)
                        }
//                        print("result")
//                        print(dic)
                    }
                }
                catch(let err){
                    print(err)
                }
            }
            group.leave()
        }
        group.enter()
        task.resume()
        group.wait()
        print(Messages.count)
    }
    
    func getReponses(topicID : Int, messageID : Int)
    {
        let url = URL(string: "https://api.intra.42.fr/v2/topics/\(topicID)/messages/\(messageID)/messages")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIController.TOKEN)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup();
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? [Any]{
                        if dic.count > 0
                        {
                            self.handleReponses(dic: dic, isReply: true)
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
            group.leave()
        }
        group.enter()
        task.resume()
        group.wait()
        print(Responses.count)
    }
    
    func getUserID(login: String)
    {
//        let url = URL(string: "https://api.intra.42.fr/v2/me")
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(login)")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(APIController.TOKEN)", forHTTPHeaderField: "Authorization")
//        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        let group = DispatchGroup();
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response as Any)
            if let err = error{
                print(err)
            }
            else if let d = data{
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary,
                        let stD = dic["campus_users"] as? [[String: AnyObject]]{
                        for st in stD
                        {
                            self.id = (st["id"] as? Int)!
                        }
                    }
                }
                catch(let err){
                    print(err)
                }
            }
            group.leave()
        }
        group.enter()
        task.resume()
        group.wait()
    }
}
