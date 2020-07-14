//
//  GameView.swift
//  RichPigAction4
//
//  Created by cheng on 2020/7/13.
//  Copyright © 2020 cheng. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var backgroundImage: UIImage? {
        didSet {setNeedsDisplay()}
    }
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }

}
