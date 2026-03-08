//

//  ContentView.swift
//  BingoDrawSwiftUI
//
//  Created by Taha DEMİREL on 3.06.2025.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var timer: Timer? = nil
    @AppStorage("drawInterval") var drawInterval: Double = 2.0
    @State var numbers: [Int] = Array(1...90)
    @State var currentNumber: Int? = nil
    @State var isAutoDrawing: Bool = false
    @State var wasAutoDrawingBefore: Bool = false
    @State var showSettings: Bool = false
    @State var showResetConfirmation: Bool = false
    @AppStorage("isSoundEnabled") var isSoundEnabled: Bool = false

    let syntheizer = AVSpeechSynthesizer()
    
    var isIpad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    var isGameStarted: Bool {
        numbers.count != 90 && !numbers.isEmpty
    }
    
    var body: some View {
        NavigationStack{
            
            ZStack {
                Color(red: 0.98, green: 0.97, blue: 0.94)
                    .ignoresSafeArea()
                
                VStack {
                    
                    VStack(spacing: 30){
                        Text("CONTENT_DRAWN_NUMBER")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text(isGameStarted ? "\(currentNumber!)" : "-")
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundStyle(.red)
                            
                        
                        HStack{
                            
                            if !isGameStarted && !isAutoDrawing {
                                Button{
                                    if numbers.isEmpty {
                                        resetGame()
                                    }
                                    toggleAutoDrawing()
                                }label: {
                                    Text("CONTENT_START_BUTTON_TITLE")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10.0)
                                            .fill(.green)
                                        )
                                }


                            } else {
                                
                                Button{
                                    toggleAutoDrawing()
                                } label: {
                                    Text(isAutoDrawing ? "CONTENT_PAUSE_BUTTON_TITLE" : "CONTENT_RESUME_BUTTON_TITLE")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10.0)
                                                .fill(isAutoDrawing ? .yellow : .blue)
                                        )
                                }


                                Button{
                                    stopAutoDrawing()
                                    showResetConfirmation = true
                                } label: {
                                    Text("CONTENT_RESET_BUTTON_TITLE")
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .foregroundStyle(.white)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10.0)
                                            .fill(.orange)
                                        )
                                }

                            }
                            

                            
                        }
                        .padding(.horizontal, 30)
                        
                    }
                    .padding(.vertical, 30)
                    

                    
                    GeometryReader { geometry in
                        let screenWidth = geometry.size.width
                        let spacing: CGFloat = 8
                        let totalSpacing = spacing * 9
                        let padding: CGFloat = 10
                        let boxWidth = (screenWidth - totalSpacing - (padding * 2) ) / 10
                        VStack(spacing: spacing) {
                            ForEach(0..<9, id: \.self) { row in
                                HStack(spacing: spacing) {
                                    ForEach(1...10, id: \.self) { col in
                                        let number = row * 10 + col
                                        Text("\(number)")
                                            .frame(width: boxWidth, height: boxWidth)
                                            .background(
                                                RoundedRectangle(cornerRadius: isIpad ? 50 : 6)
                                                    .fill(!numbers.contains(number) ? .green.opacity(0.8) : .gray.opacity(0.2))
                                            )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, padding)
                    }
                    
    //                VStack{
    //                    ForEach (0...8, id: \.self) { row in
    //                        HStack {
    //                            ForEach( (row*10)+1...(row+1)*10, id: \.self) { number in
    //                                Text("\(number)")
    //                                    .frame(width: 30, height: 30)
    //                                    .background(
    //                                        RoundedRectangle(cornerRadius: 6)
    //                                            .fill(!numbers.contains(number) ? .green.opacity(0.8) : .gray.opacity(0.2))
    //                                    )
    //
    //                            }
    //                        }
    //                    }
    //                }
                    Spacer()

                }
                .navigationTitle("Tombala Matik")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .foregroundStyle(.gray)
                            
                            
                                
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isSoundEnabled.toggle()
                        }) {
                            Image(systemName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                .foregroundStyle(.gray)
                            
                            
                                
                        }
                    }
                }
                .alert("CONTENT_ALERT_TITLE", isPresented: $showResetConfirmation) {
                    Button("CONTENT_RESET_CONFIRMATION_CANCEL_BUTTON_TITLE", role: .cancel ){toggleAutoDrawing()}
                    Button("CONTENT_RESET_CONFIRMATION_RESET_BUTTON_TITLE", role: .destructive){resetGame()}
                } message: {
                    Text("CONTENT_RESET_CONFIRMATION_ALERT_MESSAGE")
                }
            }
            
        }
        .sheet(isPresented: $showSettings) {
            SettingsView(drawInterval: $drawInterval)
        }
        .onChange(of: showSettings) { newValue in
            
            if newValue {
                wasAutoDrawingBefore = isAutoDrawing
                stopAutoDrawing()
            } else if wasAutoDrawingBefore {
                toggleAutoDrawing()
            }
        }
        

    }
    
    func toggleAutoDrawing(){
       
        isAutoDrawing.toggle()
        
        if isAutoDrawing  {
            startAutoDrawing()
        } else {
            stopAutoDrawing()
        }
        
    }
    
    func startAutoDrawing() {
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        timer = Timer.scheduledTimer(withTimeInterval: drawInterval, repeats: true) {_ in
            if numbers.isEmpty {
                stopAutoDrawing()
                return
            }
            let randomIndex = Int.random(in: 0..<numbers.count)
            withAnimation {
                currentNumber = numbers[randomIndex]
            }
            if isSoundEnabled {
                speakNumber(number: numbers[randomIndex])
            }
            numbers.remove(at: randomIndex)
        }
    }
    
    func stopAutoDrawing() {
        UIApplication.shared.isIdleTimerDisabled = false
        
        timer?.invalidate()
        timer = nil
        isAutoDrawing = false
    }
    
    
    func resetGame() {
        stopAutoDrawing()
        currentNumber = nil
        numbers = Array(1...90)
        isAutoDrawing = false
    }
    
    func speakNumber (number: Int) {
        let preferredLanguage = Locale.preferredLanguages.first
        
        let utterance = AVSpeechUtterance(string: "\(number)")
        utterance.voice = AVSpeechSynthesisVoice(language: preferredLanguage)
        utterance.rate = 0.45
        utterance.pitchMultiplier = 1.2
        utterance.volume = 1.0
        syntheizer.speak(utterance)
    }
}

#Preview {
    ContentView()
}
