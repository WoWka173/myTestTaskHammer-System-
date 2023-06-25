//
//  MainPresenter.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import Foundation
import UIKit

// MARK: - Constant
enum ConstantUrl {
    static let defaultUrl = "https://api.unsplash.com/search/photos?"
}

// MARK: - CustomSection
struct CustomSection {
    var cellsModels: [CellModel]
}

//MARK: - TableViewPresenterProtocol
protocol PresenterProtocol: AnyObject {
    var view: TableViewControllerProtocol? { get set }
    var sections: [CustomSection]  { get set }
    var mainModel: [ResultFood] { get set }
    var categories: [String] { get set }
    func viewDidLoad()
    func setupData() -> [CustomSection]
    func appendData(completion: @escaping (Bool) -> Void)
    func numberOfCategories() -> Int
    func categoryModel(at index: Int) -> String
    func foodModel(at index: Int) -> ResultFood
    func indexOfCategory(_ category: String) -> Int?
    func firstIndexOfFood(with category: String) -> Int?
}

//MARK: - TableViewPresenter
final class Presenter: PresenterProtocol {
    
    //MARK: - Properties
    weak var view: TableViewControllerProtocol?
    var mainModel: [ResultFood] = []
    var networkService: NetworkServiceProtocol?
    var sections = [CustomSection(cellsModels: [])]
    let group = DispatchGroup()
    var categories: [String] = ["pizza", "drinks","fruits", "burger", "beer"]
    
    //MARK: - Init
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    //MARK: - Methods
    func firstIndexOfFood(with category: String) -> Int? {
        return mainModel.firstIndex {
            $0.category == category
        }
    }
    
    func indexOfCategory(_ category: String) -> Int? {
        return categories.firstIndex {
            $0 == category
        }
    }
    
    func foodModel(at index: Int) -> ResultFood {
        return mainModel[index]
    }
    
    func numberOfCategories() -> Int {
        Categories.allCases.count
    }
    
    func categoryModel(at index: Int) -> String {
        return categories[index]
    }
    
    func viewDidLoad() {
        appendData(completion: { _ in
            self.reloadTable()
            DispatchQueue.main.async {
                self.view?.checkOut()
            }
        })
    }
    
    func appendData(completion: @escaping (Bool) -> Void) {
        for category in Categories.allCases {
            let category = category.rawValue
            self.group.enter()
            networkService?.fetchData(category: category, completion: { result in
                var arrayResult: [ResultFood] = result
                for (index, value) in arrayResult.enumerated() {
                    arrayResult[index].category = category
                }
                self.mainModel += arrayResult
                self.group.leave()
                
                result.forEach  { image in
                    self.group.enter()
                    if let url = URL(string: image.urls?.regular ?? ConstantUrl.defaultUrl) {
                        self.networkService?.downloadImage(url: url, completion: { _ in
                            self.group.leave()
                        })
                    }
                }
                
            })
        }
        self.group.notify(queue: DispatchQueue.main) {
            completion(true)
        }
    }
    
    
    func reloadTable() {
        var arrayIndexPath: [IndexPath] = []
        
        for numberOfRows in 0...24 {
            arrayIndexPath.append(IndexPath(row: numberOfRows, section: 0))
        }
        self.view?.tableViewBuilder.presenter?.sections = self.setupData()
        DispatchQueue.main.async {
            self.view?.tableViewBuilder.tableView?.beginUpdates()
            self.view?.tableViewBuilder.tableView?.insertRows(at: arrayIndexPath, with: .bottom)
            self.view?.tableViewBuilder.tableView?.endUpdates()
        }
    }
    
    func setupData() -> [CustomSection]  {
        self.mainModel.forEach { model in
            
            let onFill: (CustomCell) -> Void = { cell in
                cell.descriptionLabel.text = model.description ?? "None"
                if let url = URL(string: model.urls?.regular ?? ConstantUrl.defaultUrl) {
                    self.networkService?.getCachedImage(url: url, completion: { image in
                        cell.photoImageView.image = image
                    })
                }
            }
            let onSelect: (IndexPath) -> Void = { indexPath in
                //тап по ячейке
            }
            
            let cellModel = CellModel(onFill: onFill, onSelect: onSelect)
            self.sections[0].cellsModels.append(cellModel)
        }
        return sections
    }
}
