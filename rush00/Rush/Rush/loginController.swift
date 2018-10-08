//
//  loginController.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/07.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit
import WebKit

class loginController: UIViewController, WKNavigationDelegate {

    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserData.api.connect()
        let urlStr = "https://api.intra.42.fr/oauth/authorize?client_id=922cae07ef7938a297e7a3a38c3feb28a7ebdd661c7d533ab3b664fa4b16cc57&redirect_uri=http%3A%2F%2Fsignin.intra.42.fr%2F&response_type=code"
        let url = URL(string: urlStr)
        let request = URLRequest(url : url!)
        webView.load(request)
        webView.navigationDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var link: String = (webView.url?.absoluteString)!;
        if (link.contains("http://signin.intra.42.fr/"))
        {
            let str  = (webView.url?.absoluteString)!;
            let array = str.components(separatedBy: "=");
            Code = array[array.count - 1];
            let HomeViewPage:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "table") as! ViewController;
                self.navigationController?.pushViewController(HomeViewPage, animated: true)
        }
        link = "";
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !Code.isEmpty
        {
            UserData.api.resetState()
            exit(EXIT_SUCCESS)
//            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(false)
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
