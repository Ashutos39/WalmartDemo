//
//  HomeTableViewCell.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import UIKit

protocol HomeTableViewCellDelegate {
    
}


class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var astronomyImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ExplanationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        astronomyImageView.addCornerRadius(withRadius: 15.0)
    }
    
    func setUpUI(data: NewsDetails) {
        titleLabel.text = data.title ?? ""
        dateLabel.text = data.date ?? ""
        ExplanationLabel.text = data.explanation ?? ""
        guard let imageData = data.imageData else { return }
        astronomyImageView.image = UIImage(data: imageData)
    }
}

