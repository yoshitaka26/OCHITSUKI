//
//  ProjectCell.swift
//  OCHITSUKI
//
//  Created by Yoshitaka on 2020/10/08.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class ProjectCell: UITableViewCell {
    
    @IBOutlet weak var projectLaber: UILabel!
    @IBOutlet weak var orderAmountLaber: UILabel!
    @IBOutlet weak var dateLaber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
