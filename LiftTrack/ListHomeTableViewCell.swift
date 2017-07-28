//
//  ListHomeTableViewCell.swift
//  LiftTrack
//
//  Created by Antoine Simon on 29/06/2017.
//  Copyright © 2017 Viseo Digital. All rights reserved.
//

import UIKit

class ListHomeTableViewCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var exoName: UILabel!
    @IBOutlet weak var kg: UILabel!
    @IBOutlet weak var rep: UILabel!
    @IBOutlet weak var serie: UILabel!
    
    var idExo = String()
    var idExoList = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
