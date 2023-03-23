//
//  OpenedMoment.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/3/23.
//

import SwiftUI

struct OpenedMoment: View {
    @State var moment: MomentModel = MomentModel(id: 0, authorID: 0, time: "12:37am", post: "Lorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor LoremLorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem", photo: "cat")
    @ObservedObject var people: PeopleDictionary
    @ObservedObject var comments: CommentDictionary
    @Binding var showMoment: Bool
    @State var selectedPhoto = ""
    // MAIN VIEW
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundColor
            VStack {
                OpenedMomentHeader(moment: moment, people: people, showMoment: $showMoment, selectedPhoto: $selectedPhoto)
                divider
                ZStack(alignment: .top) {
                    allComments
                    likeButton
                }
                Spacer()
            }
            textField
            openedPhoto
        }
        .ignoresSafeArea()
    }
    
    //COMPONENTS
    var divider: some View {
        Rectangle()
            .foregroundColor(.secondaryColor)
            .frame(width: screenWidth, height: 5)
            .padding(.top, 8)
    }
    
    var allComments: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading, spacing: 5) {
                ForEach(comments.comments, id: \.self) { item in
                    Comment(comment: item, people: people)
                }
            }
        }
        .frame(width: screenWidth - 32, alignment: .leading)
    }
    
    var likeButton: some View {
        HStack{
            Spacer()
            LikeButton()
                .padding(.trailing, 22)
        }
    }
    
    var textField: some View {
        VStack {
            divider
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
                            .opacity(1)
                            .rotationEffect(Angle(degrees: 45))
                            .offset(x: -3)
                    )
            }
        }
        .padding(.bottom, 8)
        .background(Color.backgroundColor)
    }
    
    @ViewBuilder var openedPhoto: some View {
        if selectedPhoto != "" {
            ZStack {
                Color.black.ignoresSafeArea()
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
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
                .offset(y: 32)
            }
        }
    }
}

struct OpenedMomentHeader: View {
    @State var moment: MomentModel = MomentModel(id: 0, authorID: 0, time: "12:37am", post: "Lorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor LoremLorem ipsum dolor Lorem ipsum Lorem ipsum dolor Lorem Lorem ipsum dolor Lorem", photo: "cat")
    @ObservedObject var people: PeopleDictionary
    @State var isShowingLongPost = false
    @Binding var showMoment: Bool
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedPhoto: String
    var body: some View {
        HStack (alignment: .top, spacing: 0) {
            ZStack (alignment: .bottomTrailing) {
                HStack (spacing: 0) {
                    navigationButton
                    VStack (alignment: .leading, spacing: 5){
                        textBubbleContent
                    }
                    .padding(10)
                    .frame(width: screenWidth/1.293, alignment: .leading)
                    .padding(.top, -5)
                    .background(Color.softWhite)
                    .clipShape(ChatBubbleShape(direction: .left))
                }
                showLongTextButton
            }
            Spacer()
            momentPhoto
        }
        .padding(.top, 40)
        .background(Color.backgroundColor)
    }
    
    var textBubbleContent: some View {
        Group {
            HStack (spacing: 5) {
                Image(people.person[moment.authorID].photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                Text(people.person[moment.authorID].name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            HStack {
                Text(moment.post)
                    .font(.subheadline.weight(.light))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .lineLimit(isShowingLongPost ? 13 : 4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
        }
    }
    var navigationButton: some View {
        Button(action: {
            withAnimation(.linear.speed(2)){
                showMoment.toggle()
            }
        }) {
            Image(systemName: "chevron.left")
                .padding(.leading, 8)
                .foregroundColor(Color.black)
        }
        .offset(y: 5)
    }
    @ViewBuilder var showLongTextButton: some View {
        if moment.post.count > 180 {
            Button(action: {
                withAnimation {
                    isShowingLongPost.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.backgroundColor)
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundColor(Color.softWhite)
                    Image(systemName: isShowingLongPost ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color.primaryColor)
                        .font(.caption)
                }
                .contentShape(Circle())
            }
            .offset(x: -3, y: 10)
        }
    }
    @ViewBuilder var momentPhoto: some View {
        if !moment.photo.isEmpty {
            Image(moment.photo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 65)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 8)
                .onTapGesture {
                    withAnimation {
                        selectedPhoto = moment.photo
                    }
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
struct LikeButton: View {
    @State private var circleSize = 0.0
    @State private var circleInnerBorder = 35
    @State private var circleHue = 200
    @State var hasBeenLiked = false
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color.white)
                Circle()
                    .frame(width: 26, height: 26)
                    .foregroundColor(hasBeenLiked ? .accent : .backgroundColor)
                ZStack {
                    Text("💜")
                        .font(hasBeenLiked ? .caption2 : .footnote)
                    Circle()
                        .strokeBorder(lineWidth:  CGFloat(circleInnerBorder))
                        .animation(Animation.easeInOut(duration: 0.5).delay(0.1), value: hasBeenLiked)
                        .frame(width: 26, height: 26, alignment: .center)
                        .foregroundColor(Color(.systemPink))
                        .hueRotation(Angle(degrees: Double(circleHue)))
                        .scaleEffect(CGFloat(circleSize))
                        .animation(Animation.easeInOut(duration: 0.5), value: hasBeenLiked)
                }
            }
        }
        .onTapGesture {
            hasBeenLiked = true
            circleSize = 1.3
            circleInnerBorder = 0
            circleHue = 300
            let impactLight = UIImpactFeedbackGenerator(style: .soft)
            impactLight.impactOccurred()
        }
    }
}



struct OpenedMomentHeader_Previews: PreviewProvider {
    static var previews: some View {
        OpenedMoment(people: PeopleDictionary(), comments: CommentDictionary(), showMoment: .constant(false))
    }
}
