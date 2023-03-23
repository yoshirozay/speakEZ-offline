//
//  Timeline.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/2/23.
//

import SwiftUI

struct Timeline: View {
    @ObservedObject var moments: MomentDictionary
    @ObservedObject var people: PeopleDictionary
    @StateObject var comments = CommentDictionary()
    @State var showMoment = false
    @State var selectedMoment = MomentModel(id: 0, authorID: 0, time: "", post: "")
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(moments.moments.sorted(by: {$0.time > $1.time}), id: \.self) { item in
                    Moment(moment: item, people: people)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                selectedMoment = item
                                showMoment.toggle()
                            }
                        }
                    Rectangle()
                        .foregroundColor(.secondaryColor)
                        .frame(width: screenWidth, height: 5)
                }
            }
        }
        .background(Color.backgroundColor)
        .ignoresSafeArea()
        .fullSwipePop(show: $showMoment) {
            OpenedMoment(moment: selectedMoment, people: people, comments: comments, showMoment: $showMoment)
        }
    }
}

struct Timeline_Previews: PreviewProvider {
    static var previews: some View {
        Timeline(moments: MomentDictionary(), people: PeopleDictionary())
    }
}
