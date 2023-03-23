//
//  Messages.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/4/23.
//

import SwiftUI

struct MessageModel: Codable, Identifiable, Hashable {
    let id: Int
    let authorID: Int
    let message: String
    let time: String
}
class MessageDictionary: ObservableObject {
    @Published var messages: [MessageModel] = [
        MessageModel(id: 0, authorID: 0, message:"Lorem ipsum dolor sit amet", time: "9:42pm"),
        MessageModel(id: 1, authorID: 1, message:"Consectetur adipiscing elit, sed do eiusmod tempor", time: "9:40pm"),
        MessageModel(id: 2, authorID: 2, message:"Incididunt ut labore", time: "9:12pm"),
        MessageModel(id: 3, authorID: 3, message:"Viverra aliquet eget sit amet. Cursus sit amet dictum sit amet justo donec enim. Convallis aenean et tortor at risus viverra adipiscing. ", time: "7:38pm"),
        MessageModel(id: 4, authorID: 4, message:"Mi in nulla posuere sollicitudin aliquam ultrices", time: "7:30am"),
        MessageModel(id: 5, authorID: 5, message:"Eget felis eget nunc lobortis mattis. In nulla posuere sollicitudin aliquam ultrices. Feugiat sed lectus vestibulum mattis ullamcorper velit sed", time: "7:15pm"),
        MessageModel(id: 6, authorID: 6, message:"Lorem ipsum dolor sit amet", time: "6:45pm"),
        MessageModel(id: 7, authorID: 7, message:"Mi in nulla posuere sollicitudin aliquam ultrices", time: "6:32pm"),
        MessageModel(id: 8, authorID: 8, message:"Eget felis eget nunc lobortis mattis. In nulla posuere sollicitudin aliquam ultrices.", time: "4:15pm"),
        MessageModel(id: 9, authorID: 9, message:"Lorem ipsum dolor sit amet", time: "2:45pm"),
    ]
}

struct Messages: View {
    @ObservedObject var currentTab: CurrentTab
    @ObservedObject var people: PeopleDictionary
    @StateObject var messages = MessageDictionary()
    @State var showConversation = false
    @State var conversationID = 0
    // MAIN VIEW
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                header
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(messages.messages, id: \.self) { item in
                            MessagePreview(people: people, message: item)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation {
                                        conversationID = item.authorID
                                        showConversation.toggle()
                                    }
                                }
                            Rectangle()
                                .frame(width: screenWidth - 40, height: 2)
                                .foregroundColor(Color.accent.opacity(0.2))
                        }
                    }
                    .padding(.vertical)
                    .background(Color.softWhite
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
                }
                .padding(.top, -8)
                Spacer()
            }
        }
        .fullSwipePop(show: $showConversation) {
            Conversation(showConversation: $showConversation, people: people, messages: messages, friendID: conversationID)
        }
    }
    // COMPONENTS
    var header: some View {
        HStack {
            TitleHeader(title: "Messages") {
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

struct MessagePreview: View {
    @ObservedObject var people: PeopleDictionary
    var message: MessageModel = MessageModel(id: 0, authorID: 0, message: "That's so funny", time: "9:45am")
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Image(people.person[message.authorID].photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                Rectangle()
                    .frame(width: 2, height: 40)
                    .foregroundColor(message.authorID % 2 == 0 ? Color.purple : Color.red.opacity(0.8))
                    .offset(x: -35, y: 0)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(people.person[message.authorID].name)
                    .font(.headline)
                Text(message.message)
                    .font(.caption)
                    .lineLimit(2)
            }
            .foregroundColor(Color.black)
            Spacer(minLength: 0)
            VStack {
                Text(message.time)
                    .font(.caption)
                    .padding(.top, 12)
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 20)
    }
}

struct Conversation: View {
    @Binding var showConversation: Bool
    @ObservedObject var people: PeopleDictionary
    @ObservedObject var messages: MessageDictionary
    var friendID: Int
    // MAIN VIEW
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                conversationHeader
                Spacer()
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(messages.messages.prefix(9), id: \.self) { item in
                            ChatBubble(message: item)
                                .padding(.horizontal, 5)
                        }
                    }
                    .background(Color.softWhite
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.vertical, -10)
                        .padding(.bottom, -10)
                    )
                    .padding(.top, 16)
                }
            }
            textField
        }
    }
    
    // COMPONENTS
    var conversationHeader: some View {
        HStack {
            Button(action: {
                withAnimation {
                    showConversation.toggle()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.bold))
                    .foregroundColor(Color.black)
            }
            Spacer()
            Text(people.person[friendID].name)
                .font(.title3.weight(.semibold))
                .foregroundColor(Color.black)
                .offset(x: 5)
            Spacer()
            Image(people.person[friendID].photo)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal)
        .offset(y: -3)
    }
    
    var textField: some View {
        VStack {
            Rectangle()
                .foregroundColor(.secondaryColor)
                .frame(width: screenWidth, height: 5)
                .padding(.top, 8)
            HStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(width: screenWidth - 85, height: 60)
                    .foregroundColor(Color.softWhite)
                    .overlay (
                        HStack {
                            Text("Comment")
                                .font(.body.weight(.light))
                                .foregroundColor(Color.primaryColor.opacity(0.6))
                                .offset(x: 10)
                            Spacer()
                        }
                    )
                Circle()
                    .foregroundColor(Color.softWhite)
                    .frame(width: 60, height: 60)
                    .overlay (
                        Image(systemName: "paperplane.fill")
                            .font(.title)
                            .foregroundColor(Color.black)
                            .rotationEffect(Angle(degrees: 45))
                            .offset(x: -3)
                    )
            }
        }
        .padding(.bottom, 8)
        .background(Color.backgroundColor)
    }
}

struct ChatBubble: View {
    var message: MessageModel
    var body: some View {
        if message.id % 2 == 0 {
            HStack {
                Spacer(minLength: 100)
                Text(message.message)
                    .padding(.trailing, 16)
                    .padding([.leading, .vertical], 10)
                    .background(Color.accent)
                    .foregroundColor(Color.secondaryColor)
                    .clipShape(ChatBubbleShape(direction: .right))
            }
        } else {
            HStack {
                Text(message.message)
                    .padding(.leading, 16)
                    .padding([.trailing, .vertical], 10)
                    .background(Color.softWhite)
                    .foregroundColor(Color.black)
                    .clipShape(ChatBubbleShape(direction: .left))
                Spacer(minLength: 100)
            }
        }
    }
}

struct Messages_Previews: PreviewProvider {
    static var previews: some View {
        Messages(currentTab: CurrentTab(), people: PeopleDictionary())
    }
}
