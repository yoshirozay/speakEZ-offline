//
//  ContentView.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        IntroductionController()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding(currentView: .constant(.onboarding))
    }
}

