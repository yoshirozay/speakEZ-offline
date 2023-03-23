//
//  Extensions.swift
//  speakEZ offline
//
//  Created by Carson O'Sullivan on 3/1/23.
//

import SwiftUI
import Foundation

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height

struct TitleHeader: View {
    var title: String
    var action: () -> Void
    var body: some View {
        HStack (spacing: 16) {
            Button(action: {
                action()
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.bold))
                    .padding(.leading)
                    .foregroundColor(Color.black)
            }
            Text(title)
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(Color.black)
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Color {
    static let backgroundColor = Color("backgroundColor")
    static let accent = Color("accent")
    static let softWhite = Color("softWhite")
    static let primaryColor = Color("primaryColor")
    static let secondaryColor = Color("secondaryColor")
}

struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }
    
    let direction: Direction
    
    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? getLeftBubblePath(in: rect) : getRightBubblePath(in: rect)
    }
    
    private func getLeftBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 21, y: 0))
            p.addCurve(to: CGPoint(x: 4, y: 20),
                       control1: CGPoint(x: 12, y: 0),
                       control2: CGPoint(x: 4, y: 8))
            p.addLine(to: CGPoint(x: 4, y: height - 11))
            p.addCurve(to: CGPoint(x: 0, y: height),
                       control1: CGPoint(x: 4, y: height - 1),
                       control2: CGPoint(x: 0, y: height))
            p.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: 11.0, y: height - 4.0),
                       control1: CGPoint(x: 4.0, y: height + 0.5),
                       control2: CGPoint(x: 8, y: height - 1))
            p.addCurve(to: CGPoint(x: 25, y: height),
                       control1: CGPoint(x: 16, y: height),
                       control2: CGPoint(x: 20, y: height))
            
        }
        return path
    }
    
    private func getRightBubblePath(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 21, y: 0))
            p.addCurve(to: CGPoint(x: width - 4, y: 20),
                       control1: CGPoint(x: width - 12, y: 0),
                       control2: CGPoint(x: width - 4, y: 8))
            p.addLine(to: CGPoint(x: width - 4, y: height - 11))
            p.addCurve(to: CGPoint(x: width, y: height),
                       control1: CGPoint(x: width - 4, y: height - 1),
                       control2: CGPoint(x: width, y: height))
            p.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            p.addCurve(to: CGPoint(x: width - 11, y: height - 4),
                       control1: CGPoint(x: width - 4, y: height + 0.5),
                       control2: CGPoint(x: width - 8, y: height - 1))
            p.addCurve(to: CGPoint(x: width - 25, y: height),
                       control1: CGPoint(x: width - 16, y: height),
                       control2: CGPoint(x: width - 20, y: height))
            
        }
        return path
    }
}

extension View{
    
    // Creating a Property for View to access easily...
    func fullSwipePop<Content: View>(show: Binding<Bool>, content: @escaping () -> Content)-> some View{
        
        return FullSwipePopHelper(show: show, mainContent: self, content: content())
    }
}

private struct FullSwipePopHelper<MainContent: View,Content: View>: View{
    
    // Where main Content will be our main view...
    // since we are moving our main left when overlay view shows....
    var mainContent: MainContent
    var content: Content
    @Binding var show: Bool
    init(show: Binding<Bool>, mainContent: MainContent,content: Content){
        self._show = show
        self.content = content
        self.mainContent = mainContent
    }
    
    // Gesture Properties...
    @GestureState var gestureOffset: CGFloat = 0
    @State var offset: CGFloat = 0
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View{
        
        // Geometry Reader for Getting Screen width for gesture calc...
        GeometryReader{proxy in
            
            mainContent
            // Moving main Content Slightly....
                .offset(x: show && offset >= 0 ? getOffset(size: proxy.size.width) : 0)
                .overlay(
                    
                    ZStack{
                        
                        if show{
                            
                            content
                            // adding Bg same as Color scheme...
                                .background(
                                    
                                    (colorScheme == .dark ? Color.black : Color.white)
                                    // shadow...
                                        .shadow(radius: 1.3)
                                        .ignoresSafeArea()
                                )
                                .offset(x: offset > 0 ? offset : 0)
                            // Adding Gesture...
                                .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                                    
                                    out = value.translation.width
                                }).onEnded({ value in
                                    
                                    // Close if pass...
                                    withAnimation(.linear.speed(2)){
                                        //                                        offset = 0
                                        
                                        let translation = value.translation.width
                                        
                                        let maxtranslation = proxy.size.width / 5
                                        
                                        if translation > maxtranslation{
                                            show = false
                                        }
                                    }
                                    
                                }))
                                .transition(.move(edge: .trailing))
                        }
                    }
                )
            // Updating Offset...
            // This is why bcx it will update only for valid touch....
                .onChange(of: gestureOffset) { newValue in
                    offset = gestureOffset
                }
        }
    }
    
    func getOffset(size: CGFloat)->CGFloat{
        
        let progress = offset / size
        
        // Were slighlty moving the view 80 towards left side...
        // and getting back to 0 based on user drag.....
        let start: CGFloat = -80
        let progressWidth = (progress * 90) <= 90 ? (progress * 90) : 90
        
        let mainOffset = (start + progressWidth) < 0 ? (start + progressWidth) : 0
        
        return mainOffset
    }
}

