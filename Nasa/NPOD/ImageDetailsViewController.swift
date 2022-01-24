//
//  ImageDetailsViewController.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import UIKit

class ImageDetailsViewController: UIViewController {

    // MARK:- IBOutlets
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionView: UITextView!
    
    var viewModel: ImageDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        guard let modelData = self.viewModel else {
            return
        }
        self.imageTitle.text = modelData.imageTitle
        self.descriptionView.text = modelData.descriptionText
        let uiImage = modelData.uiImage
        let ratio = uiImage.size.height/uiImage.size.width
        let newHeight = self.imageVIew.frame.width * ratio
        self.imageViewHeightConstraint.constant = newHeight
        self.imageVIew.image = modelData.uiImage
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
