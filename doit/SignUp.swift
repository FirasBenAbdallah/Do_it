//
//  SignUp.swift
//  doit
//
//  Created by FirasBenAbdallah on 7/4/2023.
//

import UIKit

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var doit: UILabel!
    @IBOutlet weak var showHidePassword1: UIButton!
    @IBOutlet weak var showHideConfPass1: UIButton!
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
        
        
        if validateInput() {
            let phone = phone.text!
            let fullname = fullname.text!
            let email = email.text!
            let date = date.text!
            let address = address.text!
            let password = password.text!
            let confpass = confpass.text!
            
            let url = URL(string: "http://172.17.3.120:3000/signup")!
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
            // Navigate to the login view (assuming you have a segue with identifier "toLoginView")
            //performSegue(withIdentifier: "SignupToLogin", sender: self)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SignupToLogin" {
            // Check if input validation fails
            if !validateInput() {
                // Return false to prevent the segue from being performed
                return false
            }
        }
        // Return true to allow the segue to proceed for other identifiers
        return true
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
        
        phone.placeholder = NSLocalizedString("Phone number", comment: "phone")
        email.placeholder = NSLocalizedString("E-mail", comment: "mail")
        password.placeholder = NSLocalizedString("Password", comment: "pass")
        confpass.placeholder = NSLocalizedString("Confirm Password", comment: "confpass")
        fullname.placeholder = NSLocalizedString("Full Name", comment: "fullname")
        address.placeholder = NSLocalizedString("Address", comment: "address")
        signup.setTitle(NSLocalizedString("SIGN UP", comment: "signup"), for: .normal)
    }
    
    
    func validateInput() -> Bool {
        var isValid = true
        
        // Validate Full Name
        if fullname.text?.isEmpty ?? true {
            isValid = false
            // Create an attributed string with the red color for the placeholder
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Fullname not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            fullname.attributedPlaceholder = attributedPlaceholder
            fullname.borderColor = UIColor(.red)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.fullname.borderColor = UIColor(named: "AccentColor")
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Fullname", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.fullname.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Validate Phone Number
        if phone.text?.isEmpty ?? true || !isValidPhoneNumber(phone.text ?? "") {
            isValid = false
            // Create an attributed string with the red color for the placeholder
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Phone not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            phone.attributedPlaceholder = attributedPlaceholder
            phone.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.phone.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Phone", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.phone.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Validate Email
        if email.text?.isEmpty ?? true || !isValidEmail(email.text ?? "") {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Email not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            email.attributedPlaceholder = attributedPlaceholder
            email.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.email.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.email.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Validate Date || !isValidDate(date.text ?? "")
        if date.text?.isEmpty ?? true  {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Date not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            date.attributedPlaceholder = attributedPlaceholder
            date.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.date.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "JJ/MM/AAAA", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.date.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Validate Address
        if address.text?.isEmpty ?? true {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Address not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            address.attributedPlaceholder = attributedPlaceholder
            address.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.address.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Address", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.address.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Validate Password
        if password.text?.isEmpty ?? true  {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Password not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            password.attributedPlaceholder = attributedPlaceholder
            password.layer.borderColor = UIColor.red.cgColor
            showHidePassword1.tintColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.password.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    self.showHidePassword1.tintColor = UIColor(named: "AccentColor")
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Password", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.password.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        
        // Validate Confirm Password
        if confpass.text?.isEmpty ?? true || confpass.text != password.text {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Confpass not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            confpass.attributedPlaceholder = attributedPlaceholder
            confpass.layer.borderColor = UIColor.red.cgColor
            showHideConfPass1.tintColor = UIColor.red
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.confpass.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    self.showHideConfPass1.tintColor = UIColor(named: "AccentColor")
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.confpass.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Display error messages or highlight fields if needed
        if !isValid {
            doit.textColor = UIColor.red
            imageView.tintColor = .red
            signup.backgroundColor = UIColor.red
            
            // Shake animation
            let shakeAnimation = CABasicAnimation(keyPath: "position")
            shakeAnimation.duration = 0.07
            shakeAnimation.repeatCount = 4
            shakeAnimation.autoreverses = true
            shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: signup.center.x - 10, y: signup.center.y))
            shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: signup.center.x + 10, y: signup.center.y))
            signup.layer.add(shakeAnimation, forKey: "shake")
            
            // Delay the execution of code using DispatchQueue
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.signup.backgroundColor = UIColor(named: "AccentColor") // Replace with the desired background color
                    self.doit.textColor = UIColor(named: "AccentColor")
                    self.imageView.tintColor = UIColor(named: "AccentColor")
                }
                
                // Remove the shake animation
                self.signup.layer.removeAnimation(forKey: "shake")
            }
        }
        
        return isValid
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = #"^\d.*\d$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phoneNumber)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Use regular expressions to validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
