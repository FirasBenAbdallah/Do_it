//
//  Acceuil.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI


struct Acceuil: View {
    @State private var isMenuOpen = false
    var body: some View {
        NavigationView {
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all).toolbarBackground(Color.blue, for: .navigationBar)
                if isMenuOpen {
                    // Menu content
                    VStack(alignment: .leading, spacing: 20) {
                        Image("Profile")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        Text("John Doe")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Divider()
                            .background(Color.white)
                        
                        NavigationLink(
                            destination: Text("Settings"),
                            label: {
                                Label("Settings", systemImage: "gear")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        )
                        
                        NavigationLink(
                            destination: Text("About"),
                            label: {
                                Label("About", systemImage: "info.circle")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        )
                        
                        Spacer()
                        
                        Button(action: {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                            UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                        }, label: {
                            Label("LogOut", systemImage: "power")
                                .font(.headline)
                                .foregroundColor(.white)
                        })
                    }
                    .padding(.top, 50)
                    .padding(.horizontal, 30)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color("Menu"))
                    .transition(.move(edge: .leading))
                    .zIndex(1)
                }
                /*NavigationView {
                            List {
                                ForEach(publications) { publication in
                                    VStack(alignment: .leading, spacing: 16) {
                                        HStack(alignment: .top, spacing: 16) {
                                        Image(publication.friendImageName)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .clipShape(Circle())
                                            Text(publication.friendName)
                                                .font(.headline)
                                        }
                                        Text(publication.content)
                                            .font(.body)
                                        Image(publication.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 200)
                                            .clipped()
                                        HStack (alignment: .top, spacing: 16){
                                            Image(systemName: "hand.thumbsup")
                                            .foregroundColor(.blue)
                                            .font(.system(size: 30))
                                                Spacer()
                                            Image(systemName: "hand.thumbsdown")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 30))
                                            Spacer()
                                            Image(systemName: "text.bubble")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 30))
                                            Spacer()
                                            Image(systemName: "arrowshape.turn.up.right")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 30))
                                            Spacer()

                                        }.padding(.horizontal)
                                    }
                                }
                            }
                        .navigationBarTitle("Publications")
                        }*/
            }
            .navigationBarTitle("Do it !")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }, label: {
                Image(systemName: "line.horizontal.3")
                    .foregroundColor(.primary)
            }))

        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Acceuil_Previews: PreviewProvider {
    static var previews: some View {
        Acceuil()
    }
}
