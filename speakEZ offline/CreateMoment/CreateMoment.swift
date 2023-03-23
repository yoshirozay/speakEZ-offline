//
//  CreateMoment.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

struct CreateMoment: View {
    @State var text = "I was on a work call and didn't notice that my  Chester (my mischievous cat) had snuck up onto the windowsill. Next thing I knew, he had jumped up and was almost out the window! Thank goodness I caught him just in time"
    @State var isShowingPhoto = true
    @ObservedObject var currentTab: CurrentTab
    @ObservedObject var moments: MomentDictionary
    // MAIN VIEW
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack (alignment: .leading, spacing: 10) {
                HStack (spacing: 16) {
                    TitleHeader(title: "Moment") {
                        navigateHome()
                    }
                    Spacer()
                }
                HStack (alignment: .top, spacing: 0) {
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(Color.secondaryColor, lineWidth: 0.001)
                        .background(Color.softWhite.cornerRadius(23))
                        .frame(width: screenWidth/1.23, height: screenWidth/1.189)
                        .overlay(
                            HStack(alignment: .top)  {
                                VStack {
                                    profilePicture
                                    momentPhoto
                                    Spacer()
                                }
                                Spacer()
                                Text(text)
                                    .font(.subheadline.weight(.light))
                                    .padding([.top, .trailing], 10)
                                    .foregroundColor(Color.black)
                            }
                        )
                    VStack (spacing: 8) {
                        SendMomentButton() {
                            text = ""
                            isShowingPhoto = false
                            moments.createMoment()
                            navigateHome()
                        }
                        momentControls
                    }
                    .offset(y: -50)
                }
                .padding(.leading)
                Spacer()
            }
        }
    }
    
    // COMPONENTS
    var profilePicture: some View {
        Group {
            Image("profilePicture")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 142, height: 170)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 21, height: 21)))
                .rotation3DEffect(.degrees(3), axis: (x: 0, y: 1, z: 0))
                .padding(10)
                .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
            Text("\(text.count) / 420")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.accent)
                .offset(y: -12)
        }
    }
    
    @ViewBuilder var momentPhoto: some View {
        if isShowingPhoto {
            ZStack(alignment: .topTrailing) {
                Image("cat")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 107.7)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .rotation3DEffect(.degrees(3), axis: (x: 0, y: 1, z: 0))
                    .padding(.leading, 10)
                    .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
                Button(action: {
                    withAnimation {
                        isShowingPhoto.toggle()
                    }
                }){
                    ZStack {
                        Circle()
                            .frame(width: 23, height: 23)
                            .foregroundColor(Color.white)
                            .overlay (
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.backgroundColor)
                            )
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                }
                .offset(x: 5, y: -5)
            }
        }
    }
    
    var momentControls: some View {
        VStack(spacing: 8) {
            MomentControlsButton(imageName: "waveform") {
                
            }
            MomentControlsButton(imageName: "camera") {
                
            }
        }
    }
    
    func navigateHome() {
        currentTab.changeTab(tab: "house.fill")
    }
}

struct MomentControlsButton: View {
    var imageName = "lock"
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.accent)
                Image(systemName: imageName)
                    .font(.title3)
                    .foregroundColor(Color.secondaryColor)
            }
        }
    }
}
struct SendMomentButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Circle()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color.accent)
                    .shadow(color: Color.accent, radius: 10)
                Image(systemName: "paperplane")
                    .font(.title)
                    .foregroundColor(Color.secondaryColor)
            }
        }
        .offset(x: -2)
    }
}
struct CreateMoment_Previews: PreviewProvider {
    static var previews: some View {
        CreateMoment(currentTab: CurrentTab(), moments: MomentDictionary())
    }
}
