//
//  Permissions.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI



struct Permissions: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentView: CurrentIntroView
    @State var titleText = "Permissions"
    @State var permissionAccess = [String]()
    @Binding var selection: Int
    // MAIN VIEW
    var body: some View {
        ZStack {
            VStack {
                largePicture
                permissionDetails
                navigationButton
                Spacer()
            }
        }
        .frame(width: screenWidth/1.05, height: screenHeight / 1.1)
        .background(Color.secondaryColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // COMPONENTS
    var largePicture: some View {
        ZStack {
            
            Image(colorScheme == .light ? "permission2" : "permission1")
                .resizable()
                .scaledToFill()
                .frame(width: screenWidth/1.6, height: screenHeight/3.4) // 300, 300
            
        }
        .frame(width: screenWidth/1.05, height: screenHeight/3.087) // 300
        .padding(screenWidth/10.7) // 40
        .background(Color.secondaryColor.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var permissionDetails: some View {
        VStack (alignment: .leading, spacing: 23) {
            
            ZStack {
                Text(titleText)
                    .font(.largeTitle)
                    .foregroundColor(Color.black)
                Rectangle()
                    .frame(width: CGFloat(titleText.count * 16), height: 1)
                    .foregroundColor(Color.purple)
                    .offset(y: 20)
            }
            VStack (alignment: .leading, spacing: 23) {
                IndividualPermissions(title: "Notifications", description: "so you don't leave your friends on read", image: "bell", permissionAccess: $permissionAccess)
                Rectangle()
                    .frame(width: 30, height: 1)
                    .foregroundColor(Color.purple)
                IndividualPermissions(title: "Contacts", description: "so you can find your friends", image: "list.dash", permissionAccess: $permissionAccess)
                Rectangle()
                    .frame(width: CGFloat(titleText.count * 16 - 30), height: 1)
                    .foregroundColor(Color.purple)
            }
            
        }
        .padding(.horizontal, 14)
        
    }
    
    var navigationButton: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.3)) {
                goToNextScreen()
            }
        }) {
            Text("Done")
                .font(.headline)
                .padding()
                .padding(.horizontal, 30)
                .foregroundColor(Color.primaryColor)
                .background(Color.secondaryColor.opacity(permissionAccess.count > 0 ? 0.6 : 0.2))
                .clipShape(Capsule())
            
        }
        .padding(.top, 30)
    }
    
    func goToNextScreen() {
        withAnimation() {
            currentView = .app
        }
    }
}

struct IndividualPermissions: View {
    @State var title: String = "Camera"
    @State var description: String = "to take pictures and videos"
    @State var image: String = "camera"
    @Binding var permissionAccess: [String]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            
            Image(systemName: image)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(Color.black)
            VStack (alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
            }
            .foregroundColor(Color.black)
            Spacer()
            Button(action: {
                if permissionAccess.firstIndex(of: title) == nil {
                    permissionAccess.append(title)
                    
                } else {
                    if let firstIndex = permissionAccess.firstIndex(of: title) {
                        permissionAccess.remove(at: firstIndex)
                    }
                }
            }) {
                Circle()
                    .fill(permissionAccess.firstIndex(of: title) != nil ? Color.accent : Color.pink.opacity(0.1))
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.horizontal, 10)
        .frame(width: screenWidth/1.1, height: 70) // 300
        .background(Color.secondaryColor.opacity(colorScheme == .light ? 0.4 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct Permissions_Previews: PreviewProvider {
    static var previews: some View {
        CreateProfileController(selection: 2, currentView: .constant(.createProfile))
    }
}
