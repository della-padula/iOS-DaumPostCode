//
//  WebviewViewController.swift
//  AddressSearch
//
//  Created by TaeinKim on 2020/03/15.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebviewViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    @IBOutlet weak var webContainerView: UIView!
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "scriptHandler")
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.view = webView

        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let myBlog = "index.html"
        //        let url = URL(string: myBlog)
        //        let request = URLRequest(url: url!)
        // AddressSearch/
        let htmlPath = Bundle.main.path(forResource: "address", ofType: "html")
        let url = URL(fileURLWithPath: htmlPath!)
        let request = URLRequest(url: url)
        
        // User Agent
        webView.scrollView.isScrollEnabled = false
        
        // refresh webview
        webView.load(request)
        webView.reloadFromOrigin()
    }
    
}

extension WebviewViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
}

