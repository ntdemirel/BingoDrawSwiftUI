//
//  SettingsView.swift
//  BingoDrawSwiftUI
//
//  Created by Taha DEMİREL on 11.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var drawInterval: Double
    var body: some View {
        
        ZStack {
            Color(red: 0.98, green: 0.97, blue: 0.94)
                .ignoresSafeArea()
            
            VStack{
                Text("SETTINGS_DRAW_INTERVAL_SETTING")
                    .font(.title)

                Stepper(value: $drawInterval, in: 2...10){
                    HStack(spacing: 0) {
                        Text("SETTINGS_EVERY ")
                        Text(" \(Int(drawInterval)) ").bold().font(.title)
                        Text("SETTINGS_SECONDS_PER_DRAW")
                    }

                }
                    .padding()
                Spacer()
            }
            .padding()
        }

    }
}

#Preview {
    SettingsView(drawInterval: .constant(2.0))
}
