//
//  PostCell.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import UIKit

class PostCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    func setWidth(_ width: CGFloat) {
        if widthConstraint.constant != width {
            widthConstraint.constant = width
        }
    }
    
}
