//
//  HomeViewController.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 22/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setUpUI()
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsResponseModel == nil ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let response = viewModel.newsResponseModel else {
           return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.setUpUI(data: response)
        return cell
    }
}

extension HomeViewController: HomeViewModelDelegate {    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoader()
            self?.newsTableView.reloadData()
        }
    }
    
    func updateUIDueToInternet() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoader()
            self?.displayAlert(withMessage: Utilities.internetError, title: nil)
            self?.newsTableView.reloadData()
        }
        
    }
    
    func updateError(errorStr: String) {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoader()
            self?.showToast(message: "errorStr", font: UIFont.systemFont(ofSize: 12), color: .black)
        }
    }
}

private extension HomeViewController {
    func registerCells() {
        newsTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    func setUpUI() {
        viewModel.delegate = self
        showLoader()
        viewModel.getDataForHomeModel()
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

