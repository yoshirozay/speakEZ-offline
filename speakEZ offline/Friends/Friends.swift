//
//  Friends.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

struct Friends: View {
    @ObservedObject var currentTab: CurrentTab
    @ObservedObject var people: PeopleDictionary
    @State var text = ""
    @State var isShowingPersonProfile = false
    @State var personProfileID = 0
    // MAIN VIEW
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                HStack {
                    TitleHeader(title: "Friends") {
                        withAnimation {
                            currentTab.changeTab(tab: "house.fill")
                        }
                    }
                    Spacer()
                }
                searchBar
                ScrollView(showsIndicators: false) {
                    friendRequests
                    suggestedFriends
                    allFriends
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .fullSwipePop(show: $isShowingPersonProfile) {
            PersonProfile(person: people.person[personProfileID], isShowingProfile: $isShowingPersonProfile)
        }
    }
    
    // COMPONENTS
    var searchBar: some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 18, height: 18)
                .foregroundColor(Color.primaryColor.opacity(0.3))
            TextField("Look up a username", text: self.$text)
                .contentShape(Rectangle())
                .font(.subheadline)
                .foregroundColor(Color.black)
                .disableAutocorrection(true)
            
        }
        .frame(height: 30)
        .padding(10)
        .background(Color.softWhite)
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, -8)
    }
    
    var friendRequests: some View {
        VStack {
            HStack {
                Text("FRIEND REQUESTS")
                    .font(.headline)
                    .foregroundColor(Color.black)
                Spacer()
            }
            VStack {
                ForEach(people.person[12...14], id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            personProfileID = item.id
                            isShowingPersonProfile.toggle()
                        }
                    }) {
                        PersonRow(person: item)
                    }
                }
            }
            .padding(10)
            .background(Color.softWhite.clipShape(RoundedRectangle(cornerRadius: 8)))
        }
    }
    
    var suggestedFriends: some View {
        VStack {
            HStack {
                Text("SUGGESTED FRIENDS")
                    .font(.headline)
                    .foregroundColor(Color.black)
                Spacer()
            }
            VStack {
                ForEach(people.person[9...11], id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            personProfileID = item.id
                            isShowingPersonProfile.toggle()
                        }
                    }) {
                        PersonRow(person: item)
                    }
                }
            }
            .padding(10)
            .background(Color.softWhite.clipShape(RoundedRectangle(cornerRadius: 8)))
        }
    }
    
    var allFriends: some View {
        VStack {
            HStack {
                Text("ALL FRIENDS")
                    .font(.headline)
                    .foregroundColor(Color.black)
                Spacer()
            }
            VStack {
                ForEach(people.person[1...8], id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            personProfileID = item.id
                            isShowingPersonProfile.toggle()
                        }
                    }) {
                        PersonRow(person: item)
                    }
                }
            }
            .padding(10)
            .background(Color.softWhite.clipShape(RoundedRectangle(cornerRadius: 8)))
        }
    }
}

struct PersonRow: View {
    @State var person: Person
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack {
            Image(person.photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(person.name)
                    .fontWeight(.bold)
                Text(person.username)
                    .font(.caption)
            }
            .foregroundColor(Color.black)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}

struct PersonProfile: View {
    var person: Person
    @Binding var isShowingProfile: Bool
    // MAIN VIEW
    var body: some View {
        ZStack(alignment: .top) {
            Color.backgroundColor
                .ignoresSafeArea(.all)
            VStack (spacing: 0) {
                Image(person.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth, height: screenHeight/2, alignment: .top)
                    .clipped()
                    .ignoresSafeArea()
                VStack {
                    Text(person.name.uppercased())
                        .font(.largeTitle.weight(.semibold))
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.4))
                        .offset(y: -13)
                    Button(action: {
                        withAnimation {
                            isShowingProfile.toggle()
                        }
                    }) {
                        Text(getText())
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: screenWidth - 100)
                            .foregroundColor(Color.white)
                        
                    }
                    .background(
                        Color.backgroundColor
                    )
                    .cornerRadius(10).shadow(radius: 20)
                }
                .offset(y: -100)
            }
            navigationButton
        }
    }
    
    // COMPONENTS
    var navigationButton: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        isShowingProfile.toggle()
                    }
                }) {
                    ZStack {
                        Color.white.opacity(0.2)
                        Image(systemName: "chevron.left")
                            .font(.largeTitle.weight(.heavy))
                            .foregroundColor(Color.backgroundColor)
                            .padding(.horizontal, 5)
                    }
                    .frame(width: 20, height: 20)
                    .padding(.leading)
                    
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
    }
    
    func getText() -> String {
        if person.friends {
            return "FRIENDS"
        } else {
            return "CONFIRM FRIEND REQUEST"
        }
    }
}

struct Friends_Previews: PreviewProvider {
    static var previews: some View {
        Friends(currentTab: CurrentTab(),people: PeopleDictionary())
    }
}
