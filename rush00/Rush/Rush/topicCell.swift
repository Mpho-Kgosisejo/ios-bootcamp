//
//  topicCell.swift
//  Rush
//
//  Created by Leslie DE JAGER on 2018/10/07.
//  Copyright © 2018 Leslie DE JAGER. All rights reserved.
//

import UIKit

class topicCell: UITableViewCell {

    @IBOutlet weak var topic: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
