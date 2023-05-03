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
                        }
                        
                        Button("Select Image") {
                            self.showImagePicker = true
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: self.$selectedImage)
                    }
            VStack{
                TextField("Event Name", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.03))
                    .border(Color.accentColor)
                    .border(.red, width: CGFloat(wrongUsername))
                Spacer().frame(height: 10)
                TextField("Location", text: $location)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.03))
                    .border(Color.accentColor)
                    .border(.red, width: CGFloat(wronglocation))
                Spacer().frame(height: 10)
                DatePickerTextField(placeholder: "Starts", date: self.$date)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.03))
                    .border(Color.accentColor)
                    .border(.red, width: CGFloat(wrongstart))
                Spacer().frame(height: 10)
                DatePickerTextField2(placeholder: "Ends", date: self.$date2)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.03))
                    .border(Color.accentColor)
                    .border(.red, width: CGFloat(wrongend))
                Spacer().frame(height: 10)
                TextField("Description", text: $desc)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.03))
                    .border(Color.accentColor)
                    .border(.red, width: CGFloat(wrongdesc))
                //Spacer().frame(height: 10)
                Button("Add") {
                    var x = 1
                    if (username.count > 0){
                        wrongUsername = 0
                        x=0
                    } else {
                        wrongUsername = 1
                        x=1
                    }
                    if (location.count > 0){
                        wronglocation = 0
                        x=0
                    } else {
                        wronglocation = 1
                        x=1
                    }
                    if let unwrappedDate = date {
                        let dateString = "\(unwrappedDate)"
                        print("start: \(dateString)")
                        let dateLength = dateString.count
                            wrongstart = 0
                            x=0
                    } else {
                        wrongstart = 1
                        x=1
                    }
                    if let unwrappedDate2 = date2 {
                        let dateString2 = "\(unwrappedDate2)"
                        let dateLength2 = dateString2.count
                            wrongend = 0
                            x=0
                    } else {
                        wrongend = 1
                        x=1
                    }
                    if (desc.count > 0){
                        wrongdesc = 0
                        x=0
                    } else {
                        wrongdesc = 1
                        x=1
                    }
                    x=0
                    if x == 0 {
                        addEvent()
                    }
                }
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.accentColor)
                .cornerRadius(10)
                .padding(.top, 0)
            }
        }
        
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


