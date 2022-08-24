//
//  ContentView.swift
//  CarouselCardView
//
//  Created by Arunkumar Chandrasekar on 23/08/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentTab: Tab = .home
    @Namespace var animation
    
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 15) {
            HeaderView()
            
            SearchBar()
            
            (Text("Featured")
                .fontWeight(.semibold) +
             Text(" Movies")
            )
            .font(.title2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 15)
            
            CardView(index: $currentIndex, items: movies, cardPadding: 150, id: \.id) { movie, size in
                Image(movie.poster)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding(.horizontal, -15)
            .padding(.vertical)
            
            TabBar()
        }
        .padding([.horizontal, .top], 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            GeometryReader { geo in
                let size = geo.size
                TabView(selection: $currentIndex) {
                    ForEach(movies.indices, id: \.self) { index in
                        Image(movies[index].poster)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .tag(index)
                            .clipped()
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                
                LinearGradient(colors: [
                    Color.clear,
                    Color.gray.opacity(0.5),
                    Color.black,
                ], startPoint: .top, endPoint: .bottom)
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                (Text("Hello")
                    .fontWeight(.semibold) +
                Text(" Arun")
                )
                .font(.title2)
                
                Text("Book your favourite movie")
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
        }
    }
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20, height: 20)
            
            TextField("Search", text: .constant(""))
                .padding(.vertical, 10)
            
            Image(systemName: "mic")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.12))
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: -2) {
                    Image(systemName: tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .foregroundColor(currentTab == tab ? .white : .gray.opacity(0.6))
                    
                    if currentTab == tab {
                        Circle()
                            .fill(.white)
                            .frame(width: 5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        currentTab = tab
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
