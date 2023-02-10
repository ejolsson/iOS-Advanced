//
//  TableViewCell.swift
//  ios-practica
//
//  Created by Eric Olsson on 12/27/22.
//
//  This file complete
import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView! // only code added
    @IBOutlet weak var titleLabel: UILabel! // only code added
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
