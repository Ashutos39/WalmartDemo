//
//  UiView+Extension.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 25/11/22.
//

import Foundation
import UIKit

extension UIView {
    func addCornerRadius(withRadius cornerRadius: CGFloat) {
       
        clipsToBounds = true
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
    }
}
