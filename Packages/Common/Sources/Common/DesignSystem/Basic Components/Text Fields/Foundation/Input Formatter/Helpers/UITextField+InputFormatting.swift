//
//  UITextField+InputFormatting.swift
//  CAFU
//
//  Created by Ahmed Ramy on 22/09/2022.
//

import UIKit.UITextField

public extension UITextField {
    func setCursorLocation(_ location: Int) {
        guard let cursorLocation = position(from: beginningOfDocument, offset: location) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.selectedTextRange = strongSelf.textRange(from: cursorLocation, to: cursorLocation)
        }
    }
}
