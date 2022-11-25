//
//  CoreDataWorker.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

struct HomeCoreDataWorker {
    private let coreDataWorker: WalmartCoreDataWorkerOperations
    
    
    init() {
        coreDataWorker = WalmartCoreDataWorker()
    }

    func saveNewsDataToDB(apiResponse: NewsResponseModel, imageData: Data ,complitionHandle:  @escaping (Bool) -> Void) {
        
        coreDataWorker.performAndSave { (context: WalmartManagedObjectContext) in
            
            let newsModel = coreDataWorker.getOrCreateSingle(type: NewsDetails.self, from: context)
            newsModel.mapNewsDetailsFromApiResponse(apiResponse: apiResponse, imageData: imageData)
        } completion: { (result: WalmartVoidResult<Error>) in
            switch result {
            case .success:
                complitionHandle(true)
                debugPrint("responce saved sucessfully")
            case .failure(let failure):
                complitionHandle(false)
                debugPrint(failure.localizedDescription)
            }
        }
    }
    
    
    func fetchNewsDataFromDB( completionHandler: @escaping (NewsDetails?) -> Void) {
        coreDataWorker.get(type: NewsDetails.self) { (result: Result<[NewsDetails], Error>) in
            switch result {
            case .success(let newsModel):
                completionHandler(newsModel.first)
            case .failure(_):
                completionHandler(nil)
            }
        }

    }
    
    func removeNews(data: NewsDetails,complitionHandle:  @escaping (Bool) -> Void) {
        coreDataWorker.delete { (context) -> WalmartManagedObject in
            let newsData: NewsDetails = self.coreDataWorker.getOrCreateSingle(type: NewsDetails.self, withPredicateAttributes: ["date": data.date], from: context)
            return newsData
        } completion: { (result : WalmartVoidResult<Error>) in
            switch result {
            case .success:
                complitionHandle(true)
            case .failure(_):
                complitionHandle(false)
            }
        }
    }
}
