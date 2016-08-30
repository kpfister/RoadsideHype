//
//  hLineView.swift
//  RSA
//
//  Created by Karl Pfister on 8/29/16.
//  Copyright © 2016 Karl Pfister. All rights reserved.
//

import UIKit

@IBDesignable public final class HorizontalHairlineView: UIView {
    
    public override func intrinsicContentSize() -> CGSize {
        let screen = window?.screen ?? UIScreen.mainScreen()
        return CGSize(width: UIViewNoIntrinsicMetric, height: 1.0 / screen.scale)
    }
}
