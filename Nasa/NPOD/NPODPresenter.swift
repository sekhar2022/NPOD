//
//  NPODPresenter.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import Foundation
import UIKit

protocol NPODPresenterProtocol: AnyObject {
    var view: NPODViewProtocol? { get set }
    func fetchPicOfTheDay(for date: Date)
    func setup()
    func addPictureToFavouriteList(forTheDate date: Date)
    func removePictureFromFavouriteList(forTheDate date: Date)
    func getFavouriteList() -> [ImageDetailsViewModel]
}

class NPODPresenter {

    // MARK: - Public variables
    var networkManager: NetworkManager!
    var viewModelArray: [ImageDetailsViewModel] = []
    
    // MARK: - Private variables
    weak var view: NPODViewProtocol?

    // MARK: - Initialization
    init(with view: NPODViewProtocol?) {
        self.view = view
    }
    
    fileprivate func handleModelData(model: NPODModelData) {
        self.view?.showSpinner()
        networkManager.downloadImage(from: model.url) { localFileUrl, error in
            self.view?.hideSpinner()
            if let errorMessage = error {
                self.view?.handleAPIFailure(with: errorMessage)
                self.view?.resetDateToPrevious()
                return
            }
            guard let path = localFileUrl?.path,
                  let uiImage = UIImage(contentsOfFile: path) else {
                //
                return
            }
            if self.viewModelArray.filter({ $0.date == model.date }).isEmpty {
                let viewModel = ImageDetailsViewModel(date: model.date, imageTitle: model.title, descriptionText: model.explanation, uiImage: uiImage)
                self.view?.refreshUIWith(model: viewModel)
                self.viewModelArray.append(viewModel)
            }
        }
    }
    
    
}

extension NPODPresenter: NPODPresenterProtocol {
    
    func setup() {
        self.networkManager = NetworkManager()
        self.view?.setupUI()
    }
    
    func fetchPicOfTheDay(for date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let dateString = dateFormatter.string(from: date)

        // search in the file system
//        if let uiImage = loadImageFromDiskWith(fileName: dateString) {
//            self.view?.updateImage(image: uiImage)
//            return
//        }
        
        if let viewModel = viewModelArray.filter({ $0.date == dateString }).first {
            self.view?.refreshUIWith(model: viewModel)
            return
        }
        self.view?.showSpinner()
        networkManager.getPicOfTheDay(for: dateString) { modelData, errorMessage in
            guard let model = modelData else {
                self.view?.hideSpinner()
                self.view?.handleAPIFailure(with: errorMessage ?? "Error!!")
                self.view?.resetDateToPrevious()
                return
            }
            self.handleModelData(model: model)
        }
    }
    
    func addPictureToFavouriteList(forTheDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let dateString = dateFormatter.string(from: date)

        guard let viewModel = viewModelArray.filter({ $0.date == dateString }).first else {
            // error
            return
        }
        viewModel.isFavourite = true
    }
    
    func removePictureFromFavouriteList(forTheDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let dateString = dateFormatter.string(from: date)

        guard let viewModel = viewModelArray.filter({ $0.date == dateString }).first else {
            // error
            return
        }
        viewModel.isFavourite = false
    }
    
    func getFavouriteList() -> [ImageDetailsViewModel] {
        let favouritesList = self.viewModelArray.filter({ $0.isFavourite })
        return favouritesList
    }
}
