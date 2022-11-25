//
//  Date+Extension.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 25/11/22.
//

import Foundation

extension Date {
    func currentDate(dateFormat:String = "yyyy-MM-dd") -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
}
