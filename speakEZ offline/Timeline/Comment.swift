//
//  Comment.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/3/23.
//

import SwiftUI

struct CommentModel: Codable, Identifiable, Hashable {
    let id: Int
    let authorID: Int
    let comment: String
    let time: String
}

class CommentDictionary: ObservableObject {
    @Published var comments: [CommentModel] = [
        CommentModel(id: 0, authorID: 0, comment:"Lorem ipsum dolor sit amet", time: "9:38am"),
        CommentModel(id: 1, authorID: 1, comment:"Consectetur adipiscing elit, sed do eiusmod tempor", time: "9:40am"),
        CommentModel(id: 2, authorID: 2, comment:"Incididunt ut labore", time: "9:52am"),
        CommentModel(id: 3, authorID: 3, comment:"Viverra aliquet eget sit amet. Cursus sit amet dictum sit amet justo donec enim. Convallis aenean et tortor at risus viverra adipiscing. ", time: "9:38am"),
        CommentModel(id: 4, authorID: 4, comment:"Mi in nulla posuere sollicitudin aliquam ultrices", time: "9:40am"),
        CommentModel(id: 5, authorID: 5, comment:"Eget felis eget nunc lobortis mattis. In nulla posuere sollicitudin aliquam ultrices. Feugiat sed lectus vestibulum mattis ullamcorper velit sed", time: "9:52am"),
        CommentModel(id: 6, authorID: 6, comment:"Lorem ipsum dolor sit amet", time: "9:38am")
    ]
}

struct Comment: View {
    @State var comment: CommentModel = CommentModel(id: 0, authorID: 0, comment: "LOL no way!!", time: "9:37am")
    @ObservedObject var people: PeopleDictionary
    var body: some View {
        ZStack (alignment: .leading) {
            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    Image(people.person[comment.authorID].photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .scaledToFill()
                        .clipShape(Circle())
                    Text(people.person[comment.authorID].name)
                        .font(.headline)
                        .foregroundColor(Color.black)
                    
                    Text(comment.time)
                        .font(.caption2)
                        .foregroundColor(Color.black.opacity(0.3))
                        .offset(y: 1)
                        .padding(.trailing, 16)
                }
                .padding(.leading, 5)
                .padding(.top, 2)
                
                Text(comment.comment)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline.weight(.light))
                    .foregroundColor(Color.black)
                    .padding(.leading, 5)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 10)
                
            }
            .padding(.bottom, 12)
            .offset(x: 5, y: 2)
        }
        .background(Color.softWhite)
        .clipShape(ChatBubbleShape(direction: .left))
    }
}

struct Comment_Previews: PreviewProvider {
    static var previews: some View {
        Comment(people: PeopleDictionary())
    }
}
