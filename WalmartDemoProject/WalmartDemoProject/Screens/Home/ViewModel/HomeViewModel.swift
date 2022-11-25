//
//  HomeViewModel.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func updateUI()
    func updateError(errorStr: String)
    func updateUIDueToInternet()
}

final class HomeViewModel {
    lazy var apiWorker = HomeApiWorker()
    lazy var coredataWorker = HomeCoreDataWorker()
    
    weak var delegate: HomeViewModelDelegate?
    
    var newsResponseModel: NewsDetails?
        
    func getDataForHomeModel() {
        coredataWorker.fetchNewsDataFromDB { [weak self] newsDetailsData in
            if newsDetailsData?.date == Date().currentDate() {
                self?.newsResponseModel = newsDetailsData
                self?.delegate?.updateUI()
            } else {
                if Reachability.isConnectedToNetwork(){
                    if let newsData = newsDetailsData {
                        self?.coredataWorker.removeNews(data: newsData) { isSucess in
                            if isSucess {
                                self?.getDataFromApi()
                            }
                        }
                    } else {
                        self?.getDataFromApi()
                    }
                }else{
                    print("Internet Connection not Available!")
                    self?.newsResponseModel = newsDetailsData
                    self?.delegate?.updateUIDueToInternet()
                }
            }
        }
    }
    
    
    func getDataFromApi() {
        apiWorker.getTodaysData { [weak self] (newsData, error) in
            if error != nil {
                self?.delegate?.updateError(errorStr: error?.localizedDescription ?? "")
            }
            guard let modelData = newsData else {
                self?.delegate?.updateError(errorStr: error?.localizedDescription ?? "")
                return}
            self?.downloadImageAndUpdateApiData(modelSave: modelData)
        }
    }
}
    
private extension HomeViewModel {
    
    func downloadImageAndUpdateApiData(modelSave: NewsResponseModel) {
        guard let imageStr = modelSave.url,let url = URL(string: imageStr) else { return }
        getData(from: url) {[weak self] (data, response, error) in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            self?.updateModelToCoreData(apiResponse: modelSave, imageData: data)
        }
    }
    
    
    func updateModelToCoreData(apiResponse: NewsResponseModel, imageData: Data) {
        coredataWorker.saveNewsDataToDB(apiResponse: apiResponse, imageData: imageData) { [weak self] isSucess in
            if isSucess {
                self?.fetchDataAndUpdateUI()
            }
        }
    }
    
    func fetchDataAndUpdateUI() {
        coredataWorker.fetchNewsDataFromDB { [weak self] newsDetailsData in
            self?.newsResponseModel = newsDetailsData
            self?.delegate?.updateUI()
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
