//
//  SplashView.swift
//  BingoDrawSwiftUI
//
//  Created by Taha DEMİREL on 23.06.2025.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    let splashDelay: Double = 1.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            
            ZStack{
                Color(red: 228/255, green: 83/255, blue: 38/255).ignoresSafeArea()
                
                VStack {
                    Image("Logo")

                }

            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + splashDelay ){
                    withAnimation{
                        isActive = true
                    }
                }
            }
            
        }
    }
}

#Preview {
    SplashView()
}
