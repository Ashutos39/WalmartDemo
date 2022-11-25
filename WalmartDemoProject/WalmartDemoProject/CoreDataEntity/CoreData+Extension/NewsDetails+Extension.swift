//
//  NewsDetails+Extension.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 25/11/22.
//

import Foundation

extension NewsDetails {
    func mapNewsDetailsFromApiResponse(apiResponse: NewsResponseModel, imageData: Data) {
        self.date = apiResponse.date
        self.title = apiResponse.title
        self.explanation = apiResponse.explanation
        self.imageData = imageData
    }
}
