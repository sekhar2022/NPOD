//
//  NPODViewController.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 21/01/22.
//

import UIKit

protocol NPODViewProtocol: AnyObject {
    func setupUI()
    func refreshUIWith(model modelData: ImageDetailsViewModel)
    func showSpinner()
    func hideSpinner()
    func handleAPIFailure(with message: String)
    func resetDateToPrevious()
}

class NPODViewController: UIViewController {
    
    // MARK:- IBOutlets
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var picOfTheDayImageVIew: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addToFavouritesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Initialization
    var presenter: NPODPresenterProtocol?
    var currentPicViewModel: ImageDetailsViewModel?
    var currentSelectedDate = Date.yesterday// default- today
    
    deinit {
        debugPrint(#file)
        debugPrint(#function)
    }

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.presenter = NPODPresenter(with: self)
        self.presenter?.setup()
    }
    // MARK:- IBActions

    @IBAction func addToFavouritesButtonTapped(_ sender: UIButton) {
        if let modelData = currentPicViewModel, modelData.isFavourite {
            self.addToFavouritesButton.isSelected = false
            self.presenter?.removePictureFromFavouriteList(forTheDate: currentSelectedDate)
        } else {
            self.addToFavouritesButton.isSelected = true
            self.presenter?.addPictureToFavouriteList(forTheDate: currentSelectedDate)
        }
    }
    // MARK:- Date Picker
    func setupDatePicker() {
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date.yesterday // sometimes today's data is not avaialable
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .editingDidEnd)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let newDate = sender.date
        if currentSelectedDate.isSameDay(secondDate: newDate) {
            return
        }
        presenter?.fetchPicOfTheDay(for: newDate)
    }
    
    func showDetails() {
        self.performSegue(withIdentifier: "presentDetailsSegue", sender: self)
    }
    
    @objc func contentViewTapped() {
        self.showDetails()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard segue.identifier == "presentDetailsSegue"  else {
            return
        }
        guard let detailsViewController = segue.destination as? ImageDetailsViewController,
              let viewModelData = self.currentPicViewModel else {
            return
        }
        detailsViewController.viewModel = viewModelData
    }
}

extension NPODViewController: NPODViewProtocol {
    func setupUI() {
        setupDatePicker()
        self.picOfTheDayImageVIew.contentMode = .scaleAspectFit
        self.activityIndicator.color = UIColor.white
        self.activityIndicator.hidesWhenStopped = true
        presenter?.fetchPicOfTheDay(for: currentSelectedDate)
        self.contentView.dropShadow()
        self.picOfTheDayImageVIew.layer.cornerRadius = 6.0
        self.picOfTheDayImageVIew.layer.masksToBounds = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(contentViewTapped))
        self.contentView.addGestureRecognizer(tapGestureRecognizer)
    }

    func refreshUIWith(model modelData: ImageDetailsViewModel) {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.currentSelectedDate = self.datePicker.date
            self.imageTitle.text = modelData.imageTitle
            self.picOfTheDayImageVIew.image = modelData.uiImage
            let newAspectRatio = modelData.uiImage.size.height/modelData.uiImage.size.width
            let newHeight = self.picOfTheDayImageVIew.frame.width * newAspectRatio
            self.imageViewHeightConstraint.constant = newHeight
            let topPadding: CGFloat = 75.0
            let bottomPadding: CGFloat = 54.0
            self.contentViewHeightConstraint.constant = newHeight + topPadding + bottomPadding
            
            if modelData.isFavourite {
                self.addToFavouritesButton.isSelected = true
            } else {
                self.addToFavouritesButton.isSelected = false
            }
        }
        self.currentPicViewModel = modelData
    }

    func showSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideSpinner() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func handleAPIFailure(with message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func resetDateToPrevious() {
        DispatchQueue.main.async {
            self.datePicker.setDate(self.currentSelectedDate, animated: true)
        }
    }
}

extension NPODViewController: FavouriteItemsDataProtocol {
    func getFavouriteItemsList() -> [ImageDetailsViewModel] {
        guard let presenter = self.presenter else {
            return []
        }
        return presenter.getFavouriteList()
    }
}
