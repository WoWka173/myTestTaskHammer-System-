//
//  ViewController.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

//MARK: - Constant
fileprivate enum Constant {
    static let zero: CGFloat = 0
    static let height: CGFloat = 40
}

//MARK: - TableViewProtocol
protocol TableViewControllerProtocol: AnyObject {
    var tableViewBuilder: TableViewBuilder { get set }
    func checkOut()
    func remakeConstraintCategoryUp()
    func remakeConstraintCategoryDown()
    func bannerIsHidden()
    func showBanner()
}

//MARK: - TableView
final class MainViewController: UIViewController {
    //MARK: - Properties
    private var presenter: PresenterProtocol
    private let leftBarButtonView = BarButtonView()
    private var bannerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 300, height: 115)
        let bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannerCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        bannerCollectionView.backgroundColor = .clear
        return bannerCollectionView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = TableViewCustomFooter(frame: CGRect(x: Constant.zero, y: Constant.zero, width: view.frame.width, height: Constant.height))
        return tableView
    }()
    
    var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 88, height: 32)
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.backgroundColor = .clear
        return categoryCollectionView
    }()
    
    lazy var tableViewBuilder = TableViewBuilder(tableView: tableView, presenter: presenter, view: self)
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: - Init
    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configuration()
    }
    
    //MARK: - Methods
    private func configuration() {
        presenter.view = self
        presenter.viewDidLoad()
        setupBannerCollectionView()
        setupTableView()
        indicatorSetup()
        setupNavBar()
        setupBannerCollectionView()
        bannerCollectionView.dataSource = self
        bannerCollectionView.delegate = self
        setupCategoryCollectionView()
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
    }
    
    private func setupNavBar() {
        let item = UIBarButtonItem(customView: leftBarButtonView)
        navigationItem.leftBarButtonItem = item
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(),
                                                               for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func bannerIsHidden() {
        self.bannerCollectionView.isHidden = true
        NSLayoutConstraint.activate([
            bannerCollectionView.heightAnchor.constraint(equalToConstant: -112)
        ])
        self.view.layoutIfNeeded()
    }
    
    func showBanner() {
        self.bannerCollectionView.isHidden = false
        NSLayoutConstraint.activate([
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 112)
        ])
        self.view.layoutIfNeeded()
    }
    
    func remakeConstraintCategoryUp() {
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor),
            categoryCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16),
            categoryCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func remakeConstraintCategoryDown() {
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 34),
            categoryCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupBannerCollectionView() {
        view.addSubview(bannerCollectionView)
        bannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 7),
            bannerCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            bannerCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 112)
        ])
    }
    
    private func setupCategoryCollectionView() {
        view.addSubview(categoryCollectionView)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 24),
            categoryCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoryCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func indicatorSetup() {
        tableView.addSubview(indicator)
        indicator.startAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        ])
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 50),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Extension TableView
extension MainViewController: TableViewControllerProtocol {
    func checkOut() {
        indicator.stopAnimating()
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView === bannerCollectionView {
            return 3
        } else {
            return presenter.numberOfCategories()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === bannerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BannerCollectionViewCell.identifier,
                for: indexPath) as? BannerCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCollectionViewCell.identifier,
                for: indexPath) as? CategoryCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            let category = presenter.categoryModel(at: indexPath.row)
            cell.configure(categoryFood: category)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView === categoryCollectionView {
            
            let category = presenter.categoryModel(at: indexPath.row)
            let index = presenter.firstIndexOfFood(with: category)
            
            tableView.scrollToRow(
                at: IndexPath(row: index!, section: 0),
                at: .top,
                animated: false
            )
        }
    }
}
