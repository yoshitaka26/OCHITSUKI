//
//  UIViewContorllerExtension.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2021/11/26.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertForEmptyText(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func destructiveAlertView(withTitle: String?,
                              message: String? = nil,
                              cancelString: String? = nil,
                              cancelBlock: (() -> Void)? = nil,
                              destructiveString: String? = nil,
                              destructiveBlock: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: cancelString, handler: cancelBlock)
            .addDestructiveAction(title: destructiveString, handler: destructiveBlock)
            .show(in: self)
    }
    
    func confirmationAlertView(withTitle: String?,
                               message: String? = nil,
                               cancelString: String? = nil,
                               cancelBlock: (() -> Void)? = nil,
                               confirmString: String? = nil,
                               confirmBlock: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: cancelString, handler: cancelBlock)
            .addOkAction(title: confirmString, handler: confirmBlock)
            .show(in: self)
    }
    
    func warningAlertView(withTitle: String?, message: String? = nil, action: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: DIALOG_OK, handler: action)
            .show(in: self)
    }
    // 表示とともにタイマーをセットする
    func infoAlertViewWithTitle(title: String, message: String? = nil, afterDismiss: (() -> Void)? = nil) {
        let infoAlert = InfoAlertView(title: title, message: message, preferredStyle: .alert)
        infoAlert.afterDismiss = afterDismiss
        infoAlert.show(in: self) {
            infoAlert.timerStart()
        }
    }
}


