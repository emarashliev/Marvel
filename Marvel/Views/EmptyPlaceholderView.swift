//
//  EmptyPlaceholderView.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/31/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import UIKit

class EmptyPlaceholderView: UIView {

    @IBOutlet weak var tryAgainButton: UIButton!

    func setupView() {
        // Button shadow
        tryAgainButton.layer.shadowOpacity = 0.2
        tryAgainButton.layer.shadowRadius = 2.0
        tryAgainButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
}
