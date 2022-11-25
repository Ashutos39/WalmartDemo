//
//  UiViewController+Extension.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 25/11/22.
//

import Foundation
import UIKit

protocol WalmartAlertMessageProtocol {
    func displayAlert(withMessage message: String, title: String?)
    func displayAlert(withMessage message:String, title: String?, alertButtons buttons: [WalmartAlertButton])
}

typealias WalmartEmptyHandler = (() -> Void)
typealias WalmartAlertButton = (String, WalmartEmptyHandler?)


extension UIViewController: WalmartAlertMessageProtocol {
    
    func displayAlert(withMessage message: String, title: String? ) {
        
        let button:WalmartAlertButton = ("OK", nil)
        displayAlert(withMessage: message, title: title, alertButtons: [button])
    }
    
    func displayAlert(withMessage message:String, title: String?, alertButtons buttons: [WalmartAlertButton]) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        buttons.forEach { (data: WalmartAlertButton) in
            alertController.addAction(UIAlertAction(title: data.0, style: UIAlertAction.Style.default) { _ in
                data.1?()
            })
        }
        DispatchQueue.main.async  {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showToast(message : String, font: UIFont, color: UIColor, textColor: UIColor = .white, customDelay: TimeInterval = 0.2) {
        let sizeOftext = message.size(withAttributes: [.font: font]).width + 40
        
        var toastWidth = sizeOftext
        var height = 40
        if sizeOftext > self.view.frame.size.width {
            toastWidth = self.view.frame.size.width - 50
            height = 80
        }
        
        let toastLabel = UILabel(frame: CGRect(x:  20, y: self.view.frame.size.height-100, width: toastWidth, height: CGFloat(height)))
        toastLabel.center.x = self.view.center.x
        toastLabel.backgroundColor = color
        toastLabel.textColor = textColor
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.5
        toastLabel.layer.cornerRadius = 20
        toastLabel.numberOfLines = 0
        toastLabel.clipsToBounds  =  true
        
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: customDelay, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
