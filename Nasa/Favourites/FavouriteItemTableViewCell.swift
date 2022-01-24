//
//  FavouriteItemTableViewCell.swift
//  Nasa
//
//  Created by Chandra Sekhar Y on 23/01/22.
//

import UIKit

class FavouriteItemTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePicView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateUI(with viewModel: ImageDetailsViewModel) {
        imagePicView.image = viewModel.uiImage
        dateLabel.text = viewModel.date
        imageTitle.text = viewModel.imageTitle
    }
    
}
