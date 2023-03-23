//
//  Events.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/4/23.
//

import SwiftUI

struct EventModel: Codable, Identifiable, Hashable {
    let id: Int
    let hostID: [Int]
    let name: String
    let description: String
    let startTime: String
    let month: String
    let day: String
    let location: String
}

class EventDictionary: ObservableObject {
    @Published var events: [EventModel] = [
        EventModel(id: 0, hostID: [1,2,3], name: "Let's get loose!", description: "It's Friday, so you know we have to get jiggy! Looking forward to seeing everyone tonight, BYOB!", startTime: "Friday, 9:30PM", month: "MAR", day: "24", location: "254 University Ave"),
        EventModel(id: 1, hostID: [3,4], name: "Sushi Dinner", description: "Reservation for ten!!", startTime: "Saturday, 6:00PM", month: "MAR", day: "25", location: "Jina Sushi"),
        EventModel(id: 2, hostID: [5,6,7], name: "Movie Night", description: "Which movie is TBD", startTime: "Saturday, 8:30PM", month: "MAR", day: "25", location: "505 Albert St"),
        EventModel(id: 3, hostID: [8,9,10], name: "Study Session", description: "ECON 422 midterm is near", startTime: "Monday, 12:30PM", month: "MAR", day: "26", location: "Dunning Hall")
    ]
}

struct Events: View {
    @StateObject var events = EventDictionary()
    @ObservedObject var currentTab: CurrentTab
    @ObservedObject var people: PeopleDictionary
    @State var showEvent = false
    @State var openedEvent = EventModel(id: 0, hostID: [0], name: "", description: "", startTime: "", month: "", day: "", location: "")
    // MAIN VIEW
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                header
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(events.events, id: \.self) { item in
                            Rectangle()
                                .foregroundColor(.secondaryColor)
                                .frame(width: screenWidth, height: 5)
                                .padding(.bottom, 10)
                            EventPreview(event: item)
                                .padding(.bottom, 100)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        openedEvent = item
                                        showEvent.toggle()
                                    }
                                }
                        }
                    }
                }
            }
        }
        .fullSwipePop(show: $showEvent) {
            OpenedEvent(showEvent: $showEvent, event: openedEvent, people: people)
        }
    }
    
    // COMPONENTS
    var header: some View {
        HStack {
            TitleHeader(title: "Events") {
                currentTab.changeTab(tab: "house.fill")
            }
            Spacer()
            Image(systemName: "plus")
                .font(.title3.weight(.semibold))
                .padding(.trailing, 28)
                .foregroundColor(.black)
        }
    }
}

struct EventPreview: View {
    @State var event: EventModel
    // MAIN VIEW
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack (alignment: .top) {
                    dateAndDay
                    details
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    //COMPONENTS
    var dateAndDay: some View {
        ZStack {
            Color.accent
            ZStack {
                Color.softWhite
                VStack (spacing: 0) {
                    Text(event.month)
                        .fontWeight(.bold)
                    Rectangle()
                        .frame(width: 60, height: 2)
                    Text(event.day)
                        .fontWeight(.heavy)
                }
                .font(.title)
                .foregroundColor(Color.black)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .frame(width: 80, height: 80, alignment: .leading)
            
        } .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(width: 100, height: 100, alignment: .leading)
    }
    
    var details: some View {
        VStack (alignment: .leading) {
            Text(event.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            Text(event.startTime)
                .fontWeight(.light)
            Text(event.location)
        }
        .foregroundColor(Color.black)
    }
}

struct OpenedEvent: View {
    @Binding var showEvent: Bool
    @State var event: EventModel
    @ObservedObject var people: PeopleDictionary
    // MAIN VIEW
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack (alignment: .leading) {
                header
                hosts
                description
                attending
                invited
                Spacer()
            }
        }
    }
    
    // COMPONENTS
    var header: some View {
        HStack (spacing: 0) {
            Button(action: {
                withAnimation {
                    showEvent.toggle()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.bold))
                    .foregroundColor(Color.black)
                    .padding(.leading, 10)
            }
            EventPreview(event: event)
        }
        .padding(.bottom, 20)
        .background(Color.softWhite)
    }
    
    var hosts: some View {
        VStack (alignment: .leading) {
            Text("HOST(s)")
                .font(.footnote)
                .fontWeight(.bold)
                .padding(.horizontal)
                .foregroundColor(Color.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(event.hostID, id: \.self) { item in
                        HStack {
                            Image(people.person[item].photo)
                                .resizable()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Text(people.person[item].name)
                                .foregroundColor(Color.black)
                        }
                        .padding(5)
                        .padding(.trailing, 5)
                        .background(Color.softWhite)
                        .cornerRadius(10)
                        .padding(.trailing, 5)
                    }
                }
                .padding(.leading)
            }
        }
        .padding(.top, 8)
    }
    
    var description: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text("DESCRIPTION")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text(event.description)
                .foregroundColor(Color.black)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    var attending: some View {
        VStack(alignment: .leading) {
            Text("ATTENDING")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    ForEach(people.person[0...9].shuffled().prefix(8), id: \.self) { item in
                        HStack {
                            Image(item.photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Text(item.name)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                    }
                }
            }
            .frame(height: screenHeight/2.8)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    var invited: some View {
        VStack (alignment: .leading) {
            Text("INVITED")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            ScrollView(showsIndicators: false) {
                VStack (alignment: .leading) {
                    ForEach(people.person[10...14].shuffled().prefix(2), id: \.self) { item in
                        HStack {
                            Image(item.photo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                            Text(item.name)
                                .foregroundColor(Color.black)
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct Events_Previews: PreviewProvider {
    static var previews: some View {
        Events(currentTab: CurrentTab(), people: PeopleDictionary())
    }
}
