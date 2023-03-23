//
//  Onboarding.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI

struct Onboarding: View {
    @Binding var currentView: CurrentIntroView
    @State var selection = 1
    @State var isAnimating = false
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                OnboardingScreen(selection: 1)
                    .tag(1)
                OnboardingScreen(selection: 2)
                    .tag(2)
                OnboardingScreen(selection: 3)
                    .tag(3)
                OnboardingScreen(selection: 4)
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .ignoresSafeArea(.all)
            loginButton
        }
        .opacity(isAnimating ? 0 : 1)
        .background(Color.black.ignoresSafeArea())
    }
    
    var loginButton: some View {
        Button(action: {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    currentView = .createProfile
                }
            }
        }) {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: screenWidth/1.3, height: 55)
                .foregroundColor(Color.white)
                .overlay (
                    HStack {
                        Image("appleLogo")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text("Continue with Apple")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                )
        }
        .padding(.bottom, 50)
    }
    
}
struct OnboardingScreen: View {
    @State var selection = 1
    var body: some View {
        ZStack {
            Image(getImage())
                .resizable()
                .scaledToFill()
                .overlay(
                    LinearGradient(colors: [.black.opacity(0.5), .black.opacity(0.35), .black], startPoint: .top, endPoint: .bottom)
                )
                .offset(y: -30)
            centeredText
        }
    }
    @ViewBuilder var centeredText: some View {
        if selection == 1 {
            VStack (spacing: -10) {
                Text(getHeadline())
                    .foregroundColor(.white)
                Text(getSubeadline())
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
            }
            .offset(y: -30)
        } else {
            VStack (spacing: 10) {
                Text(getHeadline())
                    .foregroundColor(.white)
                    .font(.title.weight(.semibold))
                Text(getSubeadline())
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
                
            }
            .offset(y: -30)
        }
    }
    func getImage() -> String {
        switch selection {
        case 1:
            return "onboarding1"
        case 2:
            return "onboarding2"
        case 3:
            return "onboarding3"
        case 4:
            return "onboarding4"
        default:
            return "onboarding1"
        }
    }
    func getHeadline() -> String {
        switch selection {
        case 1:
            return "Welcome to your personal"
        case 2:
            return "150 friends"
        case 3:
            return "Be connected"
        case 4:
            return "Stay lowkey"
        default:
            return "Welcome to your personal"
        }
    }
    func getSubeadline() -> String {
        switch selection {
        case 1:
            return "speakEZ"
        case 2:
            return "No followers, no following, just your social circle."
        case 3:
            return "Create memories with the people you care about."
        case 4:
            return "What happens in your speakeasy, stays in your spakeasy."
        default:
            return "speakEZ"
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding(currentView: .constant(.onboarding))
    }
}
