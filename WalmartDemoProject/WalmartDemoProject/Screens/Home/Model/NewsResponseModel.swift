//
//  NewsResponseModel.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

struct NewsResponseModel: Codable {
    let copyright, date, explanation: String?
    let hdurl: String?
    let mediaType, serviceVersion, title: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
