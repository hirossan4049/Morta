//
//  RoutineTableViewCell.swift
//  morta
//
//  Created by unkonow on 2020/10/24.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {
    
    var indexPath:IndexPath?
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .textColor
        indexLabel.textColor = .textColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
