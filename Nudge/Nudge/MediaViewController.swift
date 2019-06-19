//
//  MediaViewController.swift
//  Nudge
//
//  Created by William Hickman on 5/27/19.
//  Copyright © 2019 William Hickman Ent. All rights reserved.
//

import UIKit
import WebKit

class MediaViewController: UIViewController {

    var media: Media?
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getVideo(stringAddress: media!.stringAddress)
    }
    
    func getVideo(stringAddress: String) {
        let url = URL(string: stringAddress)
        webView.load(URLRequest(url: url!))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
