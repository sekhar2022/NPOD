//
//  TabBarViewController.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import UIKit

protocol FavouriteItemsDataProtocol: AnyObject {
    func getFavouriteItemsList() -> [ImageDetailsViewModel]
}

class TabBarViewController: UITabBarController {

    weak var favouriteItemsDelegate: FavouriteItemsDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setup() {
        guard let viewControllers = self.viewControllers else {
            return
        }
        if let npodViewController = viewControllers.first as? NPODViewController {
            self.favouriteItemsDelegate = npodViewController
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let favouritesVC = viewController as? FavouritesViewController {
            guard let viewModelList = favouriteItemsDelegate?.getFavouriteItemsList() else {
                return
            }
            favouritesVC.setViewModelList(viewModelList)
        }
    }
}
