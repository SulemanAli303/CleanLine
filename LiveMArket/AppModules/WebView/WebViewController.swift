//
//  WebViewController.swift
//  LiveMArket
//
//  Created by Suleman Ali on 09/07/2024.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate {
    func didScuccessRedirect(_ isScuss:Bool)
}

class WebViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var callSuccssURL:String = ""
    var OTPUrl = ""
    var delegate:WebViewControllerDelegate!
    override func backButtonAction() {
        delegate.didScuccessRedirect(false)
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        type = .backWithTop
        webView.navigationDelegate = self

        if let url = URL(string: OTPUrl) {
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        } else {
            delegate.didScuccessRedirect(false)
            self.dismiss(animated: true)
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        if(navigationAction.navigationType == .other) {
            if let redirectURL = navigationAction.request.url, let url = URL(string: callSuccssURL),redirectURL.path == url.path {
                delegate.didScuccessRedirect(true)
                self.navigationController?.dismiss(animated: true)
                decisionHandler(.cancel,preferences)
                return
            }
        }
        decisionHandler(.allow,preferences)
    }

}
