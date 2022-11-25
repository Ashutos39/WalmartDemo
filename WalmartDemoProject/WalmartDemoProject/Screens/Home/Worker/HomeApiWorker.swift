//
//  HomeApiWorker.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

struct HomeApiWorker {
    
    let url =  URL(string: Utilities.getApi)
    
    func getTodaysNewsData(completionHandler: @escaping (NewsResponseModel?, String?) -> Void) {
        guard let url = url else {
            completionHandler(nil, nil)
            return
        }
        let requestUrl = URLRequest(url:  url)
        let task = URLSession.shared.dataTask(with: requestUrl) { data, response, error in
            guard error == nil else {
                completionHandler(nil, error?.localizedDescription ?? "")
                return
            }
            guard let data = data else {
                completionHandler(nil, error?.localizedDescription ?? "")
                return
            }
            do {
                let response = try? JSONDecoder().decode(NewsResponseModel.self, from: data)
                completionHandler(response, nil)
            } 
        }
        task.resume()
    }
}
