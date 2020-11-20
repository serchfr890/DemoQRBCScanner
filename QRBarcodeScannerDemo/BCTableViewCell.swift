//
//  BCTableViewCell.swift
//  QRBarcodeScannerDemo
//
//  Created by Sergio Flores Ramirez on 20/11/20.
//

import UIKit

class BCTableViewCell: UITableViewCell {

    @IBOutlet weak var bcDataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
