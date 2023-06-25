//
//  TableViewBuilder.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

//MARK: - Constatns
fileprivate enum Constants {
    static let rowHeight: CGFloat = 130
    static let heightForHeader: CGFloat = 40.0
}

//MARK: - Models
struct CellModel {
    var onFill: ((CustomCell) -> Void)?
    var onSelect: ((IndexPath) -> Void)?
    let indefication: String = "modelCell"
}

//MARK: - TableViewBuilder
final class TableViewBuilder: NSObject {
    
    //MARK: - Properties
    weak var view: MainViewController?
    weak var tableView: UITableView?
    weak var presenter: PresenterProtocol?
    private var prevIndex = 0
    var sections: [CustomSection] {
        guard let section = presenter?.sections else { return [] }
        return section
    }
    
    //MARK: - Init
    init(tableView: UITableView, presenter: PresenterProtocol, view: MainViewController) {
        super.init()
        self.presenter = presenter
        self.view = view
        self.tableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "modelCell")
    }
}

//MARK: - Extension UITableViewDelegate, UITableViewDataSource
extension TableViewBuilder: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cellsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].cellsModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.indefication  , for: indexPath) as? CustomCell else { return UITableViewCell() }
        model.onFill?(cell)
        
        if indexPath.row == sections[indexPath.section].cellsModels.count - 1 {
            let footer = tableView.tableFooterView as? TableViewCustomFooter
            footer?.indicator.startAnimating()
            footer?.indicator.isHidden = false
            self.presenter?.appendData(completion: { check in
                if check {
                    footer?.indicator.stopAnimating()
                    footer?.indicator.isHidden = true
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = sections[indexPath.section].cellsModels[indexPath.row]
        model.onSelect?(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.heightForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return Constants.heightForHeader
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableView else {
            return
        }

        if let firstIndex = tableView?.indexPathsForVisibleRows?.first?.row,
           let food = presenter?.foodModel(at: firstIndex),
           let category = food.category,
           let indexOfCategory = presenter?.indexOfCategory(category) {

            view?.categoryCollectionView.scrollToItem(
                at: IndexPath(row: indexOfCategory, section: 0),
                at: [.centeredVertically, .centeredHorizontally],
                animated: false
            )

            if let cell = view?.categoryCollectionView.cellForItem(
                at: IndexPath(row: prevIndex, section: 0)
            ) {
                cell.contentView.backgroundColor = UIColor.white
                cell.contentView.layer.borderWidth = 1
                (cell as? CategoryCollectionViewCell)!.categoryLabel.textColor = UIColor(red: 0.99,
                                                                                               green: 0.23,
                                                                                               blue: 0.41,
                                                                                               alpha: 0.4)
            }

            if let cell = view?.categoryCollectionView.cellForItem(
                at: IndexPath(row: indexOfCategory, section: 0)
            ) {
                prevIndex = indexOfCategory
                cell.contentView.backgroundColor = UIColor(red: 0.99,
                                                                 green: 0.23,
                                                                 blue: 0.41,
                                                                 alpha: 0.2)
                cell.contentView.layer.borderWidth = 0
                (cell as? CategoryCollectionViewCell)!.categoryLabel.textColor = UIColor(red: 0.99,
                                                                                               green: 0.23,
                                                                                               blue: 0.41,
                                                                                               alpha: 1)
            }
        }

        if scrollView.contentOffset.y >= 100 {
            view?.remakeConstraintCategoryUp()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view?.bannerIsHidden()
            })
        } else {
            self.view?.remakeConstraintCategoryDown()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view?.showBanner()
            })
        }
    }
}

