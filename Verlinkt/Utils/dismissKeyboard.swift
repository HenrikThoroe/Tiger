//
//  dismissKeyboard.swift
//  Tiger
//
//  Created by Henrik Thoroe on 28.06.20.
//  Copyright © 2020 Henrik Thoroe. All rights reserved.
//

import UIKit

func dismissKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
