//
//  PassRateView.swift
//  CDL
//
//  Created by Andrey Chernyshev on 01.07.2021.
//

import SwiftUI

struct PassRateView: View {
    let title: String
    var progress: CGFloat
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 16.scale))
                    .fontWeight(.regular)
                    .foregroundColor(Color(red: 31, green: 31, blue: 31))
                Spacer()
                Text(String(format: "%.0f%%", min(self.progress, 1.0) * 100.0))
                    .font(.system(size: 16.scale))
                    .fontWeight(.regular)
                    .foregroundColor(Color(red: 31, green: 31, blue: 31))
            }
            
            LineProgressView(progress: progress)
                .frame(height: 13.scale)
        }
    }
}
