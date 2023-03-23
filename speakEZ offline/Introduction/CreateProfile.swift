//
//  CreateProfile.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI
import Combine

struct CreateProfile: View {
    @State var isDoneAnimating = true
    @Binding var selection: Int
    var body: some View {
        ZStack {
            VStack {
                CreateProfileDetails(selection: $selection)
                Spacer()
            }
            .frame(width: screenWidth/1.05, height: screenHeight / 1.1)
            .background(Color.secondaryColor.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            colorAnimation
        }
    }
    @ViewBuilder var colorAnimation: some View {
        if isDoneAnimating {
            ColorAnimation(isDoneAnimating: $isDoneAnimating)
        }
    }
}


struct ColorAnimation: View {
    @Binding var isDoneAnimating: Bool
    @State var isAnimating = true
    var body: some View {
        ZStack {
            Color.black
                .opacity(isAnimating ? 1 : 0)
        }
        .ignoresSafeArea()
        .onAppear() {
            withAnimation(.easeIn(duration: 1.5)) {
                isAnimating.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isDoneAnimating.toggle()
                }
            }
        }
    }
}


struct CreateProfileDetails: View {
    @State var name: String = ""
    @State var username: String = ""
    var allowedCharacters: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E","F", "G", "H", "I", "J","K", "L", "M", "N", "O","P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    @Environment(\.colorScheme) var colorScheme
    @Binding var selection: Int
    // MAIN VIEW
    var body: some View {
        appLogo
        profileDetails
        navigationButton
    }
    
    // COMPONENTS
    var appLogo: some View {
        Image("speakEZLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: screenWidth/1.20, height: screenHeight/11)
            .opacity(0.8)
            .padding(.top, 15)
            .padding(.bottom, 10)
    }
    var profileDetails: some View {
        VStack  {
            rectangleDivider
            nameField
            rectangleDivider
            usernameField
            rectangleDivider
            profilePicture
            rectangleDivider
            
        }
        .padding(.top, 10)
    }
    var navigationButton: some View {
        HStack {
            Spacer()
            Button(action: {
                hideKeyboard()
                let impactLight = UIImpactFeedbackGenerator(style: .soft)
                impactLight.impactOccurred()
                withAnimation {
                    selection = 2
                }
            }) {
                Text("Next")
                    .font(.headline)
                    .padding(10)
                    .padding(.horizontal, 10)
                    .foregroundColor(Color.primaryColor)
                    .background(Color.secondaryColor.opacity(0.6))
                    .clipShape(Capsule())
            }
            //                .disabled(username.count > 0 ? false : true)
            //                .opacity(username.count > 0 ? 1 : 0)
            .animation(.easeIn(duration: 0.3), value: username)
            Spacer()
        }
    }
    var nameField: some View {
        HStack(spacing: 0){
            
            Text("NAME:")
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.black.opacity(1))
                .frame(width: screenWidth/3, alignment: .leading)
                .padding(.leading, 20)
            ZStack (alignment: .leading) {
                TextField("Tristan Winter", text: $name)
                    .onReceive(Just(name), perform: { _ in
                        withAnimation() {
                            self.name = String(self.name.prefix(30))
                            
                        }
                    })
                    .offset(x: 5)
                    .frame(width: screenWidth/2, height: 35)
                    .background(Color.secondaryColor.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
            Spacer()
        }
    }
    var usernameField: some View {
        HStack(spacing: 0){
            HStack (spacing: 0) {
                Text("USERNAME:")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(Color.black.opacity(1))
                
                Text("*")
                    .foregroundColor(Color.pink)
                    .offset(y: -3)
                
            }
            .frame(width: screenWidth/3, alignment: .leading)
            .padding(.leading, 20)
            TextField("tristan", text: $username)
                .onReceive(Just(username), perform: { _ in
                    withAnimation() {
                        self.username = String(self.username.prefix(20).lowercased())
                        for item in username {
                            if allowedCharacters.firstIndex(of: item) == nil {
                                if let firstIndex = username.firstIndex(of: item) {
                                    username.remove(at: firstIndex)
                                }
                            }
                        }
                    }
                })
                .offset(x: 5)
                .frame(width: screenWidth/2, height: 35)
                .background(Color.secondaryColor.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Spacer()
        }
    }
    var profilePicture: some View {
        HStack(alignment: .top, spacing: 0){
            Text("PROFILE PICTURE:")
                .font(.caption.weight(.semibold))
                .foregroundColor(Color.black.opacity(1))
                .frame(width: screenWidth/3, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 10)
            Button(action: {
                //  showImagePicker()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11)
                        .foregroundColor(Color.secondaryColor.opacity(0.5))
                    
                        .frame(width: screenWidth/2, height: (170 * (screenWidth/2/142)))
                    ZStack {
                        Image("profilePicture")
                            .resizable()
                            .opacity(0.6)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth/2 - 20, height: (170 * ((screenWidth/2/142)) - 20))
                            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.accent.opacity(colorScheme == .light ? 0.3 : 0.5))
                            )
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color.black)
                            .background(Circle().foregroundColor(.accent))
                            .frame(width: 30, height: 30)
                            .offset(x: screenWidth/4 - 15, y: screenWidth/4 + 5)
                    }
                }
            }
            Spacer()
        }
    }
    var rectangleDivider: some View {
        Rectangle()
            .frame(width: screenWidth/1.05, height: 2)
            .foregroundColor(Color.secondaryColor)
    }
}


struct CreateProfile_Preview: PreviewProvider {
    static var previews: some View {
        CreateProfileController(selection: 1, currentView: .constant(.createProfile))
    }
}
