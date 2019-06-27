//
//  WebViewController.swift
//  Talinor
//
//  Created by Taras Kibitkin on 21/06/2019.
//  Copyright © 2019 Taras Kibitkin. All rights reserved.
//

import WebKit

class WebViewConteoller: UIViewController{
    
    init(url: URL){
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var url: URL!
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        
        view.addSubview(webView)
        webView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavBar()
        view.layoutIfNeeded()
        webView.navigationDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.navigationDelegate = nil
    }
}

extension WebViewConteoller: WKNavigationDelegate{
    
}
