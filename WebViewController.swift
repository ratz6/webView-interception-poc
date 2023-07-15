import UIKit
import WebKit

class WebViewController: UIViewController,WKScriptMessageHandler {
    var webToNativeHandler : String = "webToNativeHandler"
    private let webView : WKWebView = {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        let localFileHandler = LocalFileHandler()
//        configuration.setValue(true, forKey: "allowFileAccessFromFileURLs")
        configuration.setValue(true, forKey: "allowUniversalAccessFromFileURLs")
        configuration.setURLSchemeHandler(localFileHandler, forURLScheme: "woovly")
        configuration.defaultWebpagePreferences = preferences
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        configuration.allowsInlineMediaPlayback = true
        let contentController = WKUserContentController()
        configuration.userContentController = contentController
        let webView =  WKWebView(frame: .zero, configuration : configuration)
        return webView
    }()
    
    private let url : URL
    
    init(url:URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isMultipleTouchEnabled = false
//        webView.customUserAgent = getUSerAgent()
//        DispatchQueue.main.async {
//            self.webView.load(URLRequest(url: self.url))
//        }
        webView.configuration.userContentController.add(self, name: webToNativeHandler)
        webView.load(URLRequest(url: url))
        configureButtons()
    }
    
    private func getUSerAgent() -> String {
        var userAgent : String = ""
        webView.evaluateJavaScript("navigator.userAgent") { (result, error) -> Void in
            userAgent = result as! String
            print("User-Agent:",userAgent)
        }
        return userAgent
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    private func configureButtons(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDone))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(didTapRefresh))
    }
    
    @objc private func didTapDone() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapRefresh () {
        webView.load(URLRequest(url: url))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == webToNativeHandler {
            print("data received",message.body)
        }
    }

}

