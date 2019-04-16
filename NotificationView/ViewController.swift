//
//  ViewController.swift
//  NotificationView
//
//  Created by Hayk Brsoyan on 4/16/19.
//  Copyright © 2019 Hayk Brsoyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationView.show(style: .success, titileText: "Success Notification", messageText: "Message about notification")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            NotificationView.show(style: .error, titileText: "Error Notification", messageText: "Message about notification")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            NotificationView.show(style: .loading, titileText: "Loading", messageText: "Message about notification")
        }
    }
}

