//
//  VeryHappyFaceImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class MediumFaceImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "mediumface"))
        self.image = UIImage(named: "mediumface")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "MediumFaceImage"

    }
    
}

