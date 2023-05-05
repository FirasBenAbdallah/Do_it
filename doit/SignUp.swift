//
//  SignUp.swift
//  doit
//
//  Created by FirasBenAbdallah on 7/4/2023.
//

import UIKit

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet var fullname: FormTextField!
    @IBOutlet var phone: FormTextField!
    @IBOutlet var email: FormTextField!
    @IBOutlet weak var date: FormTextField!
    @IBOutlet var address: FormTextField!
    @IBOutlet var password: FormTextField!
    @IBOutlet var confpass: FormTextField!
    
    //@IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        password.isSecureTextEntry.toggle()
            // toggle the isSecureTextEntry property to show/hide the password
            if password.isSecureTextEntry {
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            // update the button image to show/hide the password
    }
    @IBAction func showHideConfPass(_ sender: UIButton) {
        confpass.isSecureTextEntry.toggle()
            // toggle the isSecureTextEntry property to show/hide the password
            if confpass.isSecureTextEntry {
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            // update the button image to show/hide the password
    }
    
    @IBAction func signup(_ sender: UIButton) {
        
        let phone = phone.text!
        let fullname = fullname.text!
        let email = email.text!
        let date = date.text!
        let address = address.text!
        let password = password.text!
        let confpass = confpass.text!
        
        
        let url = URL(string: "http://172.17.11.114:3000/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(phone)
        print(fullname)
        print(email)
        print(date)
        print(address)
        print(password)
        print(confpass)
        
        let params: [String: Any] = ["name": fullname,
                                     "phone": phone,
                                     "email": email,
                                     "birth_date": date,
                                     "address": address,
                                     "password":password,
                                     "conf_password": confpass]
        request.httpBody = try! JSONSerialization.data(withJSONObject: params)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
                guard error == nil else {
                    print("Error: \(error!)")
                    return
                }
                
                // Check that we got back a response
                guard let response = response as? HTTPURLResponse else {
                    print("Error: did not receive response")
                    return
                }
                
                // Check that the response status code indicates success
                guard (200...299).contains(response.statusCode) else {
                    print("Error: invalid response status code \(response.statusCode)")
                    return
                }
                
                // Check that we got back some data
                guard let data = data else {
                    print("Error: did not receive data")
                    return
                }
                
                // Parse the JSON data
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Received JSON: \(json)")
                } catch {
                    print("Error parsing JSON: \(error)")
                }
        }
        task.resume()
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        createDatePicker()
    }
    
    func createDatePicker() {
        date.textAlignment = .left
        
       // toolbar
       let toolbar = UIToolbar()
       toolbar.sizeToFit()
             // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (donePressed))
              toolbar.setItems ([doneBtn], animated: true)
        // assign toolbar
        date.inputAccessoryView = toolbar
       // assign date picker to the text field
        date.inputView = datePicker
       // date picker mode
        datePicker.datePickerMode = .date
    }
    @objc func donePressed () {
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
                                              
        date.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                imageView.contentMode = .scaleAspectFill
                imageView.image = pickedImage
                imageView.layer.cornerRadius = min(imageView.frame.width, imageView.frame.height) / 2.0
                imageView.layer.masksToBounds = true
                /*let smallerDimension = min(imageView.frame.width, imageView.frame.height)
                imageView.layer.cornerRadius = smallerDimension / 2.0
                imageView.clipsToBounds = true*/
                
            }
            
            dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
