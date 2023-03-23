//
//  People.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

struct Person: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let friends: Bool
    let photo: String
}

class PeopleDictionary: ObservableObject {
    @Published var person: [Person] = [
        Person(id: 0, name: "Dalia Day", username: "@dalia", friends: true, photo: "profilePicture"),
        Person(id: 1, name: "Tristan Winter", username: "@twinter", friends: true, photo: "person1"),
        Person(id: 2, name: "Alexandra Tunt", username: "@alex", friends: true, photo: "person2"),
        Person(id: 3, name: "Tyler Akins", username: "@tyla", friends: true, photo: "person3"),
        Person(id: 4, name: "Abbey Campbell", username: "@abbs", friends: true, photo: "person4"),
        Person(id: 5, name: "Sarah Trapnier", username: "@sarahtrapnier", friends: true, photo: "person5"),
        Person(id: 6, name: "Trevor Doom", username: "@doom", friends: true, photo: "person6"),
        Person(id: 7, name: "Taylor Li", username: "@taytay", friends: true, photo: "person7"),
        Person(id: 8, name: "Gustavo Hitch", username: "@gus", friends: true, photo: "person8"),
        Person(id: 9, name: "Xavier West", username: "@xavier", friends: false, photo: "person9"),
        Person(id: 10, name: "Sascha Fierce ", username: "@xavier", friends: false, photo: "person10"),
        Person(id: 11, name: "Jimmy Carter", username: "@jcarter", friends: false, photo: "person11"),
        Person(id: 12, name: "Mary Sorenta", username: "@marys", friends: false, photo: "person12"),
        Person(id: 13, name: "Hayley Drakk", username: "@holysmokes", friends: false, photo: "person13"),
        Person(id: 14, name: "Asha Roa ", username: "@asha", friends: false, photo: "person14")
    ]
}
