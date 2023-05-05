//
//  AboutView.swift
//  doit
//
//  Created by FirasBenAbdallah on 5/5/2023.
//

import SwiftUI
import StoreKit
struct AboutView: View {
    @State var scale: CGFloat = 1
      let rouge = Color(red: 0.23, green: 0.05, blue: 0.14)
      
      var body: some View {
          VStack {
              ZStack {
                  VStack(spacing: 20) {
                      Text("About Us")
                          .font(.largeTitle)
                          .fontWeight(.bold)
                          .foregroundColor(.white)
                      
                      HStack(spacing: 20) {
                          Image("Slouma")
                              .resizable()
                              .frame(width: 100, height: 100)
                              .clipShape(RoundedRectangle(cornerRadius: 20))
                          
                          Image("FBA")
                              .resizable()
                              .frame(width: 100, height: 100)
                              .clipShape(RoundedRectangle(cornerRadius: 20))
                      }
                      
                      HStack(spacing: 20) {
                          Text("Abdesslem chebili")
                              .font(.headline)
                              .foregroundColor(.white)
                          
                          Text("Firas ben abdallah")
                              .font(.headline)
                              .foregroundColor(.white)
                      }
                      
                      HStack(spacing: 20) {
                          Button(action: {
                              if let url = URL(string: "https://www.facebook.com/slouma.chebili.1") {
                                  UIApplication.shared.open(url)
                              }
                          }) {
                              Image(systemName: "link.circle")
                                  .foregroundColor(.white)
                                  .font(.title)
                                  .padding()
                          }
                          
                          Button(action: {
                              if let url = URL(string: "https://github.com/FirasBenAbdallah") {
                                  UIApplication.shared.open(url)
                              }
                          }) {
                              Image(systemName: "link.circle")
                                  .foregroundColor(.white)
                                  .font(.title)
                                  .padding()
                          }
                      }
                      Button(action: {
                                      SKStoreReviewController.requestReview()
                                  }) {
                                      Image(systemName: "star.fill")
                                          .foregroundColor(.white)
                                          .font(.title)
                                          .padding()
                                  }
                  }
                  ForEach (1...50, id: \.self) { _ in
                      Circle()
                          .foregroundColor(Color(red: .random(in: 0.4...0.8),
                                                 green: .random(in: 0.5...0.7),
                                                 blue: .random(in: 0.1...0.5)))
                          .blendMode(.colorDodge)
                          .animation(Animation.spring(dampingFraction: 0.1)
                              .repeatForever()
                              .speed(.random(in: 0.05...0.4))
                              .delay(.random(in: 0...1)), value: scale)
                          .scaleEffect(self.scale * .random(in: 0.1...3))
                          .frame(width: .random(in: 1...100),
                                 height: CGFloat.random(in: 20...100),
                                 alignment: .center)
                          .position(CGPoint(x: .random(in: 0...1112),
                                            y: .random(in: 0...834)))
                  }
              }
              
              
              .onAppear {
                  self.scale = 1.2
              }
              .drawingGroup(opaque: false, colorMode: .linear)
              .background(Rectangle().foregroundColor(.orange))
              .ignoresSafeArea()
          }
      }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
