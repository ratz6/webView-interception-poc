import UIKit
import WebKit


class ViewController: UIViewController {
    

    private let button : UIButton = {
        let button = UIButton()
        button.setTitle("Go to WebView", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        button.addTarget(self, action: #selector(onClickWebViewButton), for: .touchUpInside)
        button.frame = CGRect(x:0,y:0,width:220,height:50)
        button.center = view.center
    }
    
    @objc func onClickWebViewButton(){
        guard let localUrl = Bundle.main.url(forResource: "index", withExtension: "html") else {
            return
        }
        print("localUrl",localUrl)
        guard let url = URL(string: "https://deawh8u9q32vw.cloudfront.net/tests/sdk/index.html") else {
            return
        }
        let vc = WebViewController(url: url);
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }

}

