//
//  AddEvent.swift
//  doit
//
//  Created by FirasBenAbdallah on 14/4/2023.
//

import SwiftUI

struct AddEvent: View {
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var wrongUsername: Int = 0
    @State private var wronglocation: Int = 0
    @State private var wrongstart: Int = 0
    @State private var wrongend: Int = 0
    @State private var wrongdesc: Int = 0
    
    @State var text: String = ""
    @State private var username = ""
    @State private var location = ""
    @State private var start = ""
    @State private var date : Date?
    @State private var date2 : Date?
    @State private var end = ""
    @State private var desc = ""
    
    var body: some View {
        VStack{
            VStack {
                        if selectedImage != nil {
                            Image(uiImage: selectedImage!)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("No image selected")
                                .foregroundColor(Color.black.opacity(0.5))
                        }
                        
                        Button("Select Image") {
                            self.showImagePicker = true
                        }
                        .padding()
                        .padding(.bottom, 20)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: self.$selectedImage)
                    }
            VStack{
                TextField("Event Name", text: $username)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 1, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(wrongUsername == 1 ? Color.red.opacity(0.7) : Color.accentColor, lineWidth: 0.5)
                        )
                    .disableAutocorrection(true)
                Spacer().frame(height: 10)

                TextField("Location", text: $location)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 1, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(wronglocation == 1 ? Color.red.opacity(0.7) : Color.accentColor, lineWidth: 0.5)
                        )
                    .disableAutocorrection(true)
                Spacer().frame(height: 10)
                
                DatePickerTextField(placeholder: "Starts", date: self.$date)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 1, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(wrongstart == 1 ? Color.red.opacity(0.7) : Color.accentColor, lineWidth: 0.5)
                        )
                    .disableAutocorrection(true)
                Spacer().frame(height: 10)
                
                DatePickerTextField2(placeholder: "Ends", date: self.$date2)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 1, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(wrongend == 1 ? Color.red.opacity(0.7) : Color.accentColor, lineWidth: 0.5)
                        )
                    .disableAutocorrection(true)
                Spacer().frame(height: 10)
                
                TextField("Description", text: $desc)
                    .padding()
                    .frame(width: 320, height: 50)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 1, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.0)
                            .stroke(wrongdesc == 1 ? Color.red.opacity(0.7) : Color.accentColor, lineWidth: 0.5)
                        )
                    .disableAutocorrection(true)
                //Spacer().frame(height: 10)
                /*Button("Add") {
                    if validateFields() {
                        addEvent()
                    }
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 0)*/
                Button(action: {
                    if validateFields() {
                        addEvent()
                    }
                }) {
                    Text("Add")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 320)
                        .background(Color.accentColor.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5, y: 2)
                        .padding(.top, 10)
                }


            }
        }
        
    }
    
    func validateFields() -> Bool {
        if username.isEmpty || location.isEmpty || date == nil || date2 == nil || desc.isEmpty {
            wrongUsername = username.isEmpty ? 1 : 0
            wronglocation = location.isEmpty ? 1 : 0
            wrongstart = date == nil ? 1 : 0
            wrongend = date2 == nil ? 1 : 0
            wrongdesc = desc.isEmpty ? 1 : 0
            return false
        }
        
        wrongUsername = 0
        wronglocation = 0
        wrongstart = 0
        wrongend = 0
        wrongdesc = 0
        return true
    }

    
    func addEvent() {
            // Set the URL of your Node.js server
            guard let url = URL(string: "http://172.17.4.2:3000/addevent") else { return }
        var dateString = ""
        var dateString2 = ""

        if let unwrappedDate = date {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd"
          dateString = dateFormatter.string(from: unwrappedDate)
          print("start: \(dateString)")
        }
        if let unwrappedDate2 = date2 {
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyy-MM-dd"
            dateString2 = dateFormatter2.string(from: unwrappedDate2)
            print("end: \(dateString2)")
        }
        
            // Set the parameters of your request
        let params = ["name": username, "address": location,"start": dateString,"end": dateString2,"description": desc, "pde":""]
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

                if (200...200).contains(httpResponse.statusCode) {
                    // Success: handle the response data here
                    print("Event added successfully")
                } else {
                    // Error: handle the response error here
                    print("Error: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    
    struct AddEvent_Previews: PreviewProvider {
        static var previews: some View {
            AddEvent()
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No need to update anything here
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        
        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                selectedImage = pickedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
}


