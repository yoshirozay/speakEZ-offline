//
//  Controller.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

class CurrentTab: ObservableObject {
    @Published var currentTab = "house.fill"
    
    func changeTab(tab: String) {
        self.currentTab = tab
    }
}

struct AppController: View {
    @StateObject var currentTab = CurrentTab()
    @StateObject var people = PeopleDictionary()
    @StateObject var moments = MomentDictionary()
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                TabView(selection: $currentTab.currentTab) {
                    Timeline(moments: moments, people: people)
                        .tag("house.fill")
                    Friends(currentTab: currentTab, people: people)
                        .tag("person")
                    CreateMoment(currentTab: currentTab, moments: moments)
                        .tag("plus")
                    Messages(currentTab: currentTab, people: people)
                        .tag("message")
                    Events(currentTab: currentTab, people: people)
                        .tag("squareshape.split.2x2")
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .background(Color.backgroundColor)
                HStack (spacing: 0) {
                    ForEach(["house.fill", "person", "plus", "message", "squareshape.split.2x2"], id: \.self) { item in
                        TabBarButton(image: item, currentTab: currentTab)
                    }
                }
                .padding(.horizontal)
                .background(Color.black)
            }
            .ignoresSafeArea()
        }
    }
}

struct TabBarButton: View {
    var image: String
    @ObservedObject var currentTab: CurrentTab
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Image(systemName: image)
                .font(.title2)
                .foregroundColor(currentTab.currentTab == image ? Color.accent : .white)
        }
        .offset(y: screenHeight < 700 ? -10 : 0)
        .frame(width: screenWidth/5, height: 66)
        .contentShape(Rectangle())
        .onTapGesture {
            currentTab.changeTab(tab: image)
        }
    }
}

struct AppController_Previews: PreviewProvider {
    static var previews: some View {
        AppController()
    }
}
