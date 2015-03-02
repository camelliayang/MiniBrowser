//
//  ViewController.swift
//  MiniBrowser
//
//  Created by yanglu on 3/1/15.
//  Copyright (c) 2015 _Camellia_. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    var webView: WKWebView
    
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var forward: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var urlField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        
        self.webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bar.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        
        view.insertSubview(webView, belowSubview: progressView)
        
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height, width])
        
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        
        let url = NSURL(string:"http://www.google.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        back.enabled = false
        forward.enabled = false
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        bar.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: urlField.text)!))
        return false
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if (keyPath == "loading") {
            back.enabled = webView.canGoBack
            forward.enabled = webView.canGoForward
        }
        if (keyPath == "estimatedProgress") {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(webView: WKWebView!, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError!) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    @IBAction func back(sender:UIBarButtonItem) {
        webView.goBack()
    }
    @IBAction func forward(sender:UIBarButtonItem) {
        webView.goForward()
    }
    @IBAction func refresh(sender:UIBarButtonItem) {
        let request = NSURLRequest(URL:webView.URL!)
        webView.loadRequest(request)
    }
    

}

