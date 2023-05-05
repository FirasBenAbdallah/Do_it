//
//  Profile.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI

struct Profile: View {
    @State private var isDarkModeEnabled = false
    @State private var isShareSheetShowing = false

    func showShareSheet() {
        isShareSheetShowing = true
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Informations personnelles")) {
                    ProfileRow(title: "Photo de profil", imageName: "profile")
                    ProfileRow(title: "Photo de couverture", imageName: "cover")
                    Button(action: {
                        showShareSheet()
                    })
                    {
                        HStack {
                            Text("Setting")
                                .foregroundColor(Color.black)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.black)
                        }
                    }.sheet(isPresented: $isShareSheetShowing) {
                        ShareSheet(activityItems: ["I just achieved my goal!"], applicationActivities: nil)
                    }
                }
                Section(header: Text("Autres")) {
                    ProfileRow(title: "Aide", imageName: "questionmark.circle")
                 //   ProfileRow(title: "Déconnexion", imageName: "arrow.right.square")
                    Toggle("Mode sombre", isOn: $isDarkModeEnabled)
                        .onChange(of: isDarkModeEnabled) { newValue in
                            if newValue {
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .flatMap { $0.windows }
                                    .first?
                                    .overrideUserInterfaceStyle = .dark
                            } else {
                                UIApplication.shared.connectedScenes
                                    .compactMap { $0 as? UIWindowScene }
                                    .flatMap { $0.windows }
                                    .first?
                                    .overrideUserInterfaceStyle = .light
                            }
                        }
                    NavigationLink(destination: LanguageView()) {
                        ProfileRow(title: "Langues", imageName: "globe")
                        
                    }
                    
                    NavigationLink(destination: AboutView()) {
                        ProfileRow(title: "Rate us", imageName: "star")
                        
                    }
                    
                }
                Button(action: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.shared.windows.first?.rootViewController?.present(viewController, animated: true, completion: nil)
                }, label: {
                    Label("LogOut", systemImage: "power")
                        .font(.headline)
                        .foregroundColor(.black)
                })
            }.navigationTitle("Profil")
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
