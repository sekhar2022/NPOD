//
//  FavouritesViewController.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import UIKit

class FavouritesViewController: UIViewController {

    var viewModelList: [ImageDetailsViewModel] = []
    var selectedItem: ImageDetailsViewModel?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let noFavouritesCellNib = UINib.init(nibName: "NoFavouritesTableViewCell", bundle: nil)
        self.tableView.register(noFavouritesCellNib, forCellReuseIdentifier: "NoFavouritesTableViewCell")
        let favouriteItemCellNib = UINib.init(nibName: "FavouriteItemTableViewCell", bundle: nil)
        self.tableView.register(favouriteItemCellNib, forCellReuseIdentifier: "FavouriteItemTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func setViewModelList(_ updatedList: [ImageDetailsViewModel]) {
        self.viewModelList = updatedList
        self.tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    func showFavouriteImageDetails() {
        self.performSegue(withIdentifier: "presentFavImageDetailsSegue", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let viewModel = self.selectedItem else {
            return
        }
        if segue.identifier == "presentFavImageDetailsSegue" {
            if let imageDetailsViewController = segue.destination as? ImageDetailsViewController {
                imageDetailsViewController.viewModel = viewModel
            }
        }
    }

}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModelList.isEmpty {
            return 1
        } else {
            return viewModelList.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewModelList.isEmpty {
            return 77.0
        } else {
            return 143.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModelList.isEmpty {
            // show no favourites cell
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NoFavouritesTableViewCell") as? NoFavouritesTableViewCell {
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteItemTableViewCell") as? FavouriteItemTableViewCell {
                let viewModel = viewModelList[indexPath.row]
                cell.updateUI(with: viewModel)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        self.selectedItem = self.viewModelList[index]
        self.showFavouriteImageDetails()
    }
}
