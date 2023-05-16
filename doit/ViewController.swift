//
//  ViewController.swift
//  doit
//
//  Created by FirasBenAbdallah on 17/3/2023.
//

import UIKit
import SwiftUI
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var back: UINavigationItem!
    @IBOutlet weak var forgotpss: UIButton!
    @IBOutlet weak var lbaccount: UILabel!
    @IBOutlet weak var signup: UIButton!
    @IBOutlet weak var lbremember: UILabel!
    
    
    @IBOutlet var emailTextField: FormTextField!
    @IBOutlet var passwordTextField: FormTextField!
    
    @IBOutlet weak var checkbox: UIButton!

    var isChecked: Bool! = false
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        // toggle the isSecureTextEntry property to show/hide the password
        if passwordTextField.isSecureTextEntry {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        // update the button image to show/hide the password
    }
    
    @IBOutlet weak var loginlg: UIButton!
    
    @IBAction func login(_ sender: UIButton) {
        let phone = emailTextField.text!
        let password = passwordTextField.text!
        
        
        let url = URL(string: "http://172.17.0.102:3000/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let params: [String: Any] = ["phone": phone, "password": password]
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
            guard (202...405).contains(response.statusCode) else {
                    print("Error: invalid response status code \(response.statusCode)")
                return
            }
            
            DispatchQueue.main.async { [self] in
                Verify(status: response.statusCode, sender: sender)
            }
            
            print(response.statusCode)
            
            // Check that we got back some data
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            // Parse the JSON data
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Received JSON: \(json?["message"] as! String)")
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()

    }
    
    @IBOutlet weak var faceIDButton: UIButton!

    @IBAction func faceIDButtonTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
       
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in with Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    // Authentication successful, perform segue or other action
                    DispatchQueue.main.async {
                        self.setup()
                    }
                } else {
                    // Authentication failed, show error message
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Authentication Failed", message: error?.localizedDescription ?? "Please try again", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            // Face ID not available, show error message
            let alertController = UIAlertController(title: "Face ID Not Available", message: error?.localizedDescription ?? "Your device does not support Face ID", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.CheckAndAdd()
        
        lbaccount.text = NSLocalizedString("Don't have an account?", comment: "login")
        lbremember.text = NSLocalizedString("Remember me", comment: "Remember me")
        
        loginlg.setTitle(NSLocalizedString("LOGIN", comment: ""), for: .normal)
        forgotpss.setTitle(NSLocalizedString("Forgot Password ?", comment: ""), for: .normal)
        signup.setTitle(NSLocalizedString("Sign Up", comment: "signup"), for: .normal)
        emailTextField.placeholder = NSLocalizedString("Phone number", comment: "email")
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "pass")
    }
    
    @IBAction func checkboxPressed(_ sender: Any) {
        if (isChecked == false) {
            checkbox.setImage (UIImage(systemName: "checkmark.square.fill"), for: .normal)
            isChecked = true
        } else {
            checkbox.setImage (UIImage(systemName: "square"), for: .normal)
            isChecked = false
        }
    }
    
    func sendMailToAnotherFile(_ password: String) {
        // Call a function in the other file and pass the password as a parameter
        Profile.processPassword(password)
    }
    
    @IBAction func saveRememberTapped(_ sender: Any) {
        if(isChecked == true) {
               UserDefaults.standard.set("1", forKey: "rememberMe")
                UserDefaults.standard.set(emailTextField.text ?? "" , forKey: "userMail")
               UserDefaults.standard.set(passwordTextField.text ?? "", forKey: "userPassword")
               print("Mail & Password Saved Successfully")
            let mail = UserDefaults.standard.value(forKey: "userMail") as? String ?? ""
            //print("Saved password: \(mail)")
            sendMailToAnotherFile(mail)
               }else{
                   UserDefaults.standard.set("2", forKey: "rememberMe")
               }
    }
    
    func CheckAndAdd(){
            if UserDefaults.standard.string(forKey: "rememberMe") == "1" {
                checkbox.setImage (UIImage(systemName: "checkmark.square.fill"), for: .normal)
                isChecked = true
                // Set values
                self.emailTextField.text = UserDefaults.standard.string(forKey: "userMail") ?? ""
                self.passwordTextField.text = UserDefaults.standard.string(forKey: "userPassword") ?? ""
            }else{
                checkbox.setImage (UIImage(systemName: "square"), for: .normal)
                isChecked = false
            }
        }

    
    func setup() {
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
    
    func ShowAlert(msg : String) {
        let alertController = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alertController.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        alertController.view.layer.cornerRadius = 15.0
        let titleAttributed = NSAttributedString(string: "Error", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.systemRed
        ])
        alertController.setValue(titleAttributed, forKey: "attributedTitle")
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        okAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func Verify(status : Int,sender: UIButton) {
        if (status == 202){
            setup()
        }else if (status == 404){
            ShowAlert(msg : "phone does not exists.")
            sender.shakeButton()
        }else if (status == 401){
            ShowAlert(msg : "Password is not correct.")
            sender.pulsate()
        }else if (status == 400){
            ShowAlert(msg : "Please fill all fields.")
            sender.flash()
        }
    }
}

@IBDesignable
class FormTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
}

