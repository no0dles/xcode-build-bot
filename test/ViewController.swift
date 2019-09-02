//
//  ViewController.swift
//  test
//
//  Created by Pascal Bertschi on 26.08.19.
//  Copyright © 2019 Pascal Bertschi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "callback", let messageBody = message.body as? String {
            print(messageBody)
        }
    }
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = Bundle.main.infoDictionary?["LaunchURL"] as! String
        let myURL = URL(string:url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = WKUserContentController()
        webConfiguration.userContentController.add(self, name: "callback")
        
        let scriptSource = "document.body.style.backgroundColor = 'red';";
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        webConfiguration.userContentController.addUserScript(script)
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        print(deviceId)
        print(UIDevice.current.model)
        print(UIDevice.current.modelName)
        print(UIDevice.current.systemVersion)
        print(UIDevice.current.systemName)
        print(UIDevice.current.name)
        view = webView
    }

}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
