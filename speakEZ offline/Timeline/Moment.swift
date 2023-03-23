//
//  Moment.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

struct MomentModel: Codable, Identifiable, Hashable {
    let id: Int
    let authorID: Int
    let time: String
    let post: String
    var photo: String = ""
}

class MomentDictionary: ObservableObject {
    @Published var moments: [MomentModel] = [
        MomentModel(id: 0, authorID: 0, time: "5:37pm", post: "I am sick and tired of shovelling snow, this is getting out of hand :')"),
        MomentModel(id: 1, authorID: 1, time: "5:18pm", post: "Where’s everyone going tonight? Let’s start at my place!", photo: "room"),
        MomentModel(id: 2, authorID: 2, time: "5:02pm", post: "STOP! You are not going to believe what happened 😂 So, I'm hanging out with my friends when I spot my TA from my economics class. I've always had a bit of a crush on him, but I never thought I'd see him out at a bar! We started chatting and it turns out we have a ton in common. We both love indie music and craft beer, and we even bonded over our mutual dislike of our professor Before I knew it, he was asking for my number!"),
        MomentModel(id: 3, authorID: 3, time: "4:45pm", post: "Still sad we didn't get a Ronaldo vs Messi World Cup final"),
        MomentModel(id: 4, authorID: 4, time: "4:21pm", post: "Why I love cottage season:", photo: "sunset"),
        MomentModel(id: 5, authorID: 5, time: "4:14pm", post: "TGIF. What’s everyone’s plans?"),
        MomentModel(id: 6, authorID: 6, time: "4:04pm", post: "it’s not croissant, it’s qUAsANt"),
        MomentModel(id: 7, authorID: 7, time: "3:58pm", post: "", photo: "dog"),
        MomentModel(id: 8, authorID: 8, time: "3:52pm", post: "I started Love Island as a joke but now I am INVESTED"),
        MomentModel(id: 9, authorID: 9, time: "3:51pm", post: "Is anyone watching Valorant Challengers, team DSG on top!!!"),
        MomentModel(id: 10, authorID: 10, time: "3:50pm", post: "About to interview for a job I really want, Jesus take the wheel!!", photo: "jesus"),
    ]
    func createMoment() {
        let newMoment = MomentModel(id: 11, authorID: 0, time: "5:45pm", post: "OMG, I just had the biggest scare of my life! 😱 I was on a work call and didn't notice that my  Chester (my mischievous cat) had snuck up onto the windowsill. Next thing I knew, he had jumped up and was almost out the window! Thank goodness I caught him just in time.")
        withAnimation {
            moments.append(newMoment)
        }
    }
}

struct Moment: View {
    @State var moment: MomentModel = MomentModel(id: 0, authorID: 0, time: "12:37am", post: "", photo: "dog")
    @ObservedObject var people: PeopleDictionary
    @Environment(\.colorScheme) var colorScheme
    @State var selectedPhoto = ""
    // MAIN VIEW
    var body: some View {
        ZStack {
            ZStack (alignment: .leading) {
                Color.backgroundColor
                HStack {
                    ZStack (alignment: .bottomTrailing) {
                        ZStack (alignment: .leading) {
                            Color.softWhite
                            
                            ZStack (alignment: .bottomTrailing) {
                                HStack {
                                    Image(people.person[moment.authorID].photo)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 142, height: 169)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .rotation3DEffect(.degrees(3), axis: (x: 0, y: 1, z: 0))
                                        .padding(.leading, 10)
                                        .shadow(color: .black.opacity(0.16), radius: 6, x: 0, y: 3)
                                    
                                    Spacer()
                                    
                                    largeMomentPhoto
                                    
                                    Text(moment.post)
                                        .font(.headline.weight(.regular))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.black)
                                        .offset(x: -2)
                                        .lineLimit(6)
                                        .offset(y: (moment.post).count > 130 && !moment.photo.isEmpty ? -20 : 0)
                                    
                                    Spacer()
                                    
                                }
                                .frame(height: 169)
                            }
                        }
                        .frame(width: screenWidth/1.1662, height: moment.post == "" ? 230 : 190)
                        .cornerRadius(23)
                        .padding(.leading, 6)
                        
                        smallMomentPhoto
                    }
                    
                    MomentVerticalControls()
                }
            }
            .frame(height: 240)
            openedPhoto
        }
    }
    
    // COMPONENTS
    @ViewBuilder var largeMomentPhoto: some View {
        if !moment.photo.isEmpty && moment.post == "" {
            ZStack (alignment: .topTrailing) {
                Image(moment.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 174, height: 205)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 22, height: 22))
                            .stroke(Color.secondaryColor, lineWidth: 3)
                    )
                Image(systemName: "sparkles")
                    .foregroundColor(.accent)
                    .font(.title3)
                    .offset(y: -5)
            }
            .onTapGesture {
                withAnimation {
                    selectedPhoto = moment.photo
                }
            }
            .offset(x: 10)
        }
    }
    
    @ViewBuilder var smallMomentPhoto: some View {
        if !moment.photo.isEmpty && moment.post != ""  {
            ZStack {
                Image(moment.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 59.5)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay(
                        RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                            .stroke(Color.secondaryColor, lineWidth: 0.5)
                    )
                
                RoundedRectangle(cornerSize: CGSize(width: 6, height: 6))
                    .frame(width: 55, height: 59.5)
                    .foregroundColor(Color.black.opacity(0.2))
            }
            .onTapGesture {
                withAnimation {
                    selectedPhoto = moment.photo
                }
            }
            .offset(x: -16, y: 20)
        }
    }
    
    @ViewBuilder var openedPhoto: some View {
        if selectedPhoto != "" {
            ZStack {
                Image(selectedPhoto)
                    .resizable()
                    .scaledToFit()
                VStack (alignment: .leading) {
                    HStack {
                        Button(action: {
                            withAnimation {
                                selectedPhoto = ""
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.largeTitle.weight(.bold))
                                .foregroundColor(.accent)
                        }
                        .background(Color.white.opacity(0.2))
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                    withAnimation {
                        selectedPhoto = ""
                    }
                }
            }
        }
    }
    
}

struct MomentVerticalControls: View {
    var body: some View {
        VStack {
            IndividualVerticalControl(image: "heart")
            IndividualVerticalControl(image: "bubble.middle.bottom")
        }
        .offset(x: -3)
    }
    func getNumber() -> String {
        let number = Int.random(in: 0..<12)
        return "\(number)"
    }
}

struct IndividualVerticalControl: View {
    var image: String
    var body: some View {
        ZStack {
            Text(getNumber())
                .font(.caption2)
                .foregroundColor(Color.white)
            Circle()
                .foregroundColor(Color.softWhite)
                .frame(width: 40, height: 40)
                .overlay (
                    Image(systemName: image)
                        .font(.title2)
                        .foregroundColor(Color.white)
                        .offset(y: 1))
        }
    }
    func getNumber() -> String {
        let number = Int.random(in: 0..<12)
        return "\(number)"
    }
}

struct Moment_Previews: PreviewProvider {
    static var previews: some View {
        Moment(people: PeopleDictionary())
    }
}
