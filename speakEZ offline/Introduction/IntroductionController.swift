//
//  IntroductionHome.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI

enum CurrentIntroView: String {
    case onboarding
    case createProfile
    case app
}

struct IntroductionController: View {
    @State var currentView: CurrentIntroView = .onboarding
    var body: some View {
        ZStack {
            switch currentView {
            case .onboarding:
                Onboarding(currentView: $currentView)
            case .createProfile:
                CreateProfileController(currentView: $currentView)
            case .app:
                AppController()
                    .frame(width: screenWidth)
            }
        }
    }
}
struct CreateProfileController: View {
    @State var selection = 1
    @Binding var currentView: CurrentIntroView
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.backgroundColor, .accent]), startPoint: .top, endPoint: .trailing)
                .ignoresSafeArea(.all)
            TabView(selection: $selection) {
                CreateProfile(selection: $selection)
                    .tag(1)
                Permissions(currentView: $currentView, selection: $selection)
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
        }
    }
}
struct IntroductionHome_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionController(currentView: .app)
    }
}
