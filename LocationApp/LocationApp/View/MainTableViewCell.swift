//
//  MainTableViewCell.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet var timerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
