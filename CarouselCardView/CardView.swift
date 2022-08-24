//
//  CardView.swift
//  CarouselCardView
//
//  Created by Arunkumar Chandrasekar on 23/08/22.
//

import SwiftUI

struct CardView<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
    var content: (Item.Element, CGSize) -> Content
    var id: KeyPath<Item.Element, ID>
    
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    
    @State var currentIndex: Int = 0
    
    @State var rotation: Double = 0
    
    init(index: Binding<Int>, items: Item, spacing: CGFloat = 30, cardPadding: CGFloat = 80, id: KeyPath<Item.Element, ID>, @ViewBuilder content: @escaping (Item.Element, CGSize) -> Content) {
        self.content = content
        self.id = id
        self._index = index
        self.items = items
        self.spacing = spacing
        self.cardPadding = cardPadding
    }
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            
            
            let cardWidth = size.width - (cardPadding - spacing)
            
            LazyHStack(spacing: spacing) {
                ForEach(items, id: id) { movie in
                    let index = indexOf(item: movie)
                    
                    content(movie, .init(width: size.width - cardPadding, height: size.height))
                        .rotationEffect(.init(degrees: Double(index) * 5), anchor: .bottom)
                        .rotationEffect(.init(degrees: rotation), anchor: .bottom)
//                        .offset(y: offsetY(index: index, cardWidth: cardWidth))
                        .frame(width: size.width - cardPadding, height: size.height)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: limitScroll())
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onChanged{
                        onChanged(value: $0, cardWidth: cardWidth)
                        
                    }
                    .onEnded{
                        onEnd(value: $0, cardWidth: cardWidth)
                        
                    }
            )
        }
        .padding(.top, 60)
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStoredOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)
        
        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let in_between = (index - 1) == self.index ? previous : next

        return index == self.index ? -60 - yOffset : in_between
    }
    
    func indexOf(item: Item.Element) -> Int {
        let array = Array(items)
        
        if let index = array.firstIndex(of: item) {
            return index
        }
        
        return 0
    }
    
    func limitScroll() -> CGFloat {
        let extraSpace = (cardPadding / 2) - spacing
        
        if index == 0 && offset > extraSpace {
            return extraSpace + (offset / 4)
        }else if index == items.count - 1 && translation < 0 {
            return offset - (translation / 2)
        }else {
            return offset
        }
    }
    
    func onChanged(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        print(translationX)
        offset = translationX + lastStoredOffset
        
        let progress = offset / cardWidth
        rotation = progress * 5
    }
    
    func onEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        withAnimation(.easeInOut(duration: 0.25)) {
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace
            
            let progress = offset / cardWidth
            rotation = (progress * 5).rounded() - 1
        }
        lastStoredOffset = offset
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}