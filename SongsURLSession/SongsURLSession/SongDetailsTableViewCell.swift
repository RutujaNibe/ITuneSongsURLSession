//
//  SongDetailsTableViewCell.swift
//  SongsURLSession
//
//  Created by Mac on 29/04/22.
//

import UIKit

class SongDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackNameLable: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var trackUrlLabel: UILabel!
    @IBOutlet weak var artNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
