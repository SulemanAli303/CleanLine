//
//  CustomAutoCompleteViewController.swift
//  EQUser
//
//  Created by Mac User on 11/10/19.
//  Copyright © 2019 A2Solution. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class CustomAutoCompleteViewController: GMSAutocompleteViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.tintColor = nil
    }
}
