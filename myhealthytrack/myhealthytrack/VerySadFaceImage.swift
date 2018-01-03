//
//  VeryHappyFaceImage.swift
//  myhealthytrack
//
//  Created by Hailey Hurt on 12/10/17.
//  Copyright © 2017 Hailey Hurt. All rights reserved.
//

import UIKit

class VerySadFaceImage: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init() {
        super.init(image: UIImage(named: "verysadface"))
        self.image = UIImage(named: "verysadface")
        self.contentMode = .scaleAspectFit
        
        accessibilityActivate()
        accessibilityLabel = "VerySadFaceImage"

    }
    
}

