//
//  ErrorRetryView.swift
//  CurrencyConvertor
//
//  Created by Hemant Shrestha on 08/09/2023.
//

import SwiftUI

struct ErrorRetryView: View {
    let title: String
    let description: String
    let actionText: LocalizedStringKey
    let action: VoidFunction
    
    init(
        title: String = "Error!",
        description: String,
        actionText: LocalizedStringKey = "Retry",
        action: @escaping VoidFunction
    ) {
        self.title = title
        self.description = description
        self.actionText = actionText
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "exclamationmark.octagon.fill")
                .resizable()
                .renderingMode(.template)
                .frame(size: 100)
                .foregroundStyle(.red)
            Text(title)
                .font(.title)
            
            Text(description)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)

            Spacer()
            
            Button(actionText, action: action)
                .buttonStyle(.borderedProminent)
                .tint(.appPrimary)
            
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 16)
    }
}

struct ErrorRetryView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorRetryView(
            description: "This the description for error",
            actionText: "Retry",
            action: {}
        )
    }
}
