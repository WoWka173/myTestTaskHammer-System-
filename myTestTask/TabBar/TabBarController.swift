//
//  TabBarController.swift
//  myTestTask
//
//  Created by Владимир Курганов on 22.06.2023.
//

import UIKit

//MARK: - TabBarController
final class TabBarController: UITabBarController {

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Methods
    private func setupTabBar() {
        let networkService: NetworkServiceProtocol = NetworkService()
        let presenter: PresenterProtocol = Presenter(networkService: networkService)
        let menuViewController = UINavigationController(rootViewController: MainViewController(presenter: presenter))
        let contactsViewController = UINavigationController(rootViewController: ContactsViewController())
        let profileViewCotroller = UINavigationController(rootViewController: ProfileViewController())
        let basketViewController = UINavigationController(rootViewController: BasketViewController())

        
        viewControllers = [menuViewController, contactsViewController, profileViewCotroller, basketViewController]
        setViewControllers([menuViewController, contactsViewController, profileViewCotroller, basketViewController], animated: true)
        tabBar.isHidden = false
        tabBar.tintColor = .red
        
        guard let items = tabBar.items else { return }
        
        let images = ["Меню", "Контакты", "Профиль", "Корзина"]
        
        for i in 0..<items.count {
                    items[i].image = UIImage(imageLiteralResourceName: images[i])
        
        }
    }
}
