//
//  TableViewUserCell.swift
//  CompanyTask1
//
//  Created by Rachana Pandit on 17/12/22.
//

import UIKit

class TableViewUserCell: UITableViewCell {

    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
