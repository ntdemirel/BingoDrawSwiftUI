//
//  SettingsView.swift
//  BingoDrawSwiftUI
//
//  Created by Taha DEMİREL on 11.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @Binding var drawInterval: Double
    @Binding var speechLanguage: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("SETTINGS_DRAW_INTERVAL_SECTION")) {
                    Stepper(value: $drawInterval, in: 2...10) {
                        HStack(spacing: 0) {
                            Text("SETTINGS_EVERY ")
                            Text(" \(Int(drawInterval)) ").bold().font(.title)
                            Text("SETTINGS_SECONDS_PER_DRAW")
                        }
                    }
                    .listRowBackground(Color.clear)
                }

                Section(header: Text("SETTINGS_SPEECH_LANGUAGE_SECTION")) {
                    Picker("SETTINGS_SPEECH_LANGUAGE_LABEL", selection: $speechLanguage) {
                        Text("SETTINGS_LANGUAGE_SYSTEM").tag("system")
                        Text("SETTINGS_LANGUAGE_TURKISH").tag("tr-TR")
                        Text("SETTINGS_LANGUAGE_ENGLISH").tag("en-US")
                        Text("SETTINGS_LANGUAGE_GERMAN").tag("de-DE")
                        Text("SETTINGS_LANGUAGE_SPANISH").tag("es-ES")
                        Text("SETTINGS_LANGUAGE_FRENCH").tag("fr-FR")
                        Text("SETTINGS_LANGUAGE_ITALIAN").tag("it-IT")
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.98, green: 0.97, blue: 0.94))
            .navigationTitle("SETTINGS_TITLE")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView(drawInterval: .constant(2.0), speechLanguage: .constant("system"))
}
