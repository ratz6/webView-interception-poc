import UIKit
import WebKit
import UniformTypeIdentifiers

class LocalFileHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        print("nishit",urlSchemeTask.request.url!)
        guard let url = urlSchemeTask.request.url,
              let fileUrl = fileUrlFromUrl(url),
              let mimeType = mimeType(ofFileAtUrl: fileUrl),
              let data = try? Data(contentsOf: fileUrl) else { return }
        print("fileUrl",fileUrl)
        let response = HTTPURLResponse(url: url,
                                       mimeType: mimeType,
                                       expectedContentLength: data.count, textEncodingName: nil)

        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }
    
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        // No cleanup necessary
        print("filePath stopped")
    }
    
    private func fileUrlFromUrl(_ url: URL) -> URL? {
        print("url is:",url.lastPathComponent,#"data/\#(url.lastPathComponent)"#)
        return Bundle.main.url(forResource: url.lastPathComponent,
                               withExtension: "")
    }

    private func mimeType(ofFileAtUrl url: URL) -> String? {
        guard let type = UTType(filenameExtension: url.pathExtension) else {
            return nil
        }
        print("mime type",type)
        return type.preferredMIMEType
    }
}
