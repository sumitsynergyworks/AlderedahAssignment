//
//  ViewResumeVC.swift
//  AlderadahCareerAssignmentSumit
//
//  Created by Technology on 06/09/22.
//

import UIKit
//import PDFKit
import WebKit

class ViewResumeVC: BaseViewController {
    
    var filePath: String?

    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let filePath = filePath , let url = URL.init(string: filePath) {
            loadWebView(url: url)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    private func loadWebView(url: URL) {
        showLoader()
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            self.webView.load(request)
        }
    }

   
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        let pdfView = PDFView(frame: view.bounds)
////        view.addSubview(pdfView)
////
////        if let url = URL(string: "https://upcdn.io/FW25auRJzrnmmdqVk9tRJ5z"), let document = PDFDocument(url: url) {
////            pdfView.document = document
////        }
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - WEBVIEW DELEGATE
extension ViewResumeVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideLoader()
        AlertManager.showOKAlert(withTitle: StringConstants.ERROR, withMessage: error.localizedDescription, onViewController: self)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }

}
