//
//  PButton.swift
//  PButton
//
//  Created by Ahmed Ramy on 16/09/2021.
//  Copyright © 2021 Proba B.V. All rights reserved.
//

import SwiftUI

struct PButton: View {
  var action: VoidCallback
  var title: String
  var icon: Image? = nil
  var color: Color = .secondary1.dark
  var body: some View {
    Button(action: action, label: {
      HStack {
        icon
        Text(title)
          .font(.displaySmall)
          .foregroundColor(.mono.offwhite)
          .padding(.p16)
      }
      .background(color)
      .cornerRadius(.p8)
    })
  }
}
