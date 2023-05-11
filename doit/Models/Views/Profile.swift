//
//  Profile.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI

var savedPhone: String?
struct Profile: View {
    @State private var isDarkModeEnabled = false
    @State private var isShareSheetShowing = false
    
    @State private var selectedLanguage = "en"
    private let languages = ["en", "fr", "ar"]

    func showShareSheet() {
        isShareSheetShowing = true
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal information")) {
                    HStack {
                        Text("Profile picture")
                            .foregroundColor(Color.black)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.black)
                    }
                    HStack {
                        Text("Cover picture")
                            .foregroundColor(Color.black)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.black)
                    }
                    Button(action: {
                        showShareSheet()
                    })
                    {
                        HStack {
                            Text("Setting")
                                //.foregroundColor(Color.black)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundColor(Color.black)
                        }
                    }.sheet(isPresented: $isShareSheetShowing) {
                        ShareSheet(activityItems: ["I just achieved my goal!"], applicationActivities: nil)
                    }
                }
                Section(header: Text("Other")) {
                    HStack {
                        Text("Help")
                            //.foregroundColor(Color.black)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(Color.black)
                    }
                    Toggle("Dark Mode", isOn: $isDarkModeEnabled)
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
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Text("Rate us")
                                .foregroundColor(Color.black)
                            Spacer()
                            //Image(systemName: "arrow.right")
                                //.foregroundColor(Color.black)
                        }
                    }
                    
                }
                VStack {
                            //Text("")
                            Picker(selection: $selectedLanguage, label: Text("Select a language:")) {
                                ForEach(languages, id: \.self) { language in
                                    Text(language)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())

                            Button("Apply") {
                                UserDefaults.standard.setValue([selectedLanguage], forKey: "AppleLanguages")
                                exit(0)
                            }.foregroundColor(.black)
                        }
                
                Button(action: {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    //logout()

                    
                }, label: {
                    Label("LogOut", systemImage: "power")
                        .font(.headline)
                        .foregroundColor(.black)
                })
            }.navigationTitle("Profile")
        }
    }
    static func processPassword(_ password: String) {
            // Do something with the password here
            savedPhone = password
            //print("Received password: \(password)")
        }
}
/*func logout() {
        // Set the URL of your Node.js server
        guard let url = URL(string: "http://172.17.6.45:3000/logout") else { return }

    
        // Set the parameters of your request
    let params = ["phone":savedPhone]
        guard let body = try? JSONSerialization.data(withJSONObject: params) else { return }

        // Create the request and set the HTTP method to POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body

        // Set the content type of the request to JSON
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Send the request using URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            // Check the status code of the response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if (200...201).contains(httpResponse.statusCode) {
                // Success: handle the response data here
                print("Logout")
                DispatchQueue.main.async {
                    // update the user interface here
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "Home")
                    UIApplication.shared.windows.first?.rootViewController = viewController
                    //.present(viewController, animated: true, completion: nil)
                }
                
            } else {
                // Error: handle the response error here
                print("Error: \(httpResponse.statusCode)")
            }
        }.resume()
    }
*/
struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
