//
//  SendCode.swift
//  doit
//
//  Created by FirasBenAbdallah on 7/4/2023.
//

import UIKit

class SendCode: UIViewController {
    
    @IBOutlet weak var sendcode: UIButton!
    @IBOutlet weak var changepass: UILabel!
    @IBOutlet weak var emailTextField: FormTextField!
    var verif = false
    
    @IBAction func sendCode(_ sender: UIButton) {
        if validateInput() {
            let email = emailTextField.text!
            
            let url = URL(string: "http://172.17.3.120:3000/sendPasswordRecoveryEmail")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            print(email)
            let params: [String: Any] = ["email": email]
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
                guard (200...405).contains(response.statusCode) else {
                    print("Error: invalid response status code \(response.statusCode)")
                    return
                }
                DispatchQueue.main.async { [self] in
                    Verify(status: response.statusCode, sender: sender)
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
    }
    
    func Verify(status : Int,sender: UIButton) {
        if (status == 404){
            ShowAlert(msg : "E-mail does not exists.")
            sender.shakeButton()
        } 
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "changeToreset" {
            // Check if input validation fails
            if !validateInput() {
                // Return false to prevent the segue from being performed
                return false
            }
        }
        return true
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        changepass.text = NSLocalizedString("Change Your Password", comment:"login")
        sendcode.setTitle(NSLocalizedString("SEND CODE", comment: ""), for: .normal)
        emailTextField.placeholder = NSLocalizedString("E-mail", comment: "E-mail")
        
        // Do any additional setup after loading the view.
    }
    
    
    func validateInput() -> Bool {
        var isValid = true
        
        // Validate Email
        if emailTextField.text?.isEmpty ?? true || !isValidEmail(emailTextField.text ?? "") {
            isValid = false
            let placeholderAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red
            ]
            let attributedPlaceholder = NSAttributedString(string: "Email not valid", attributes: placeholderAttributes)
            // Assign the attributed placeholder to the text field
            emailTextField.attributedPlaceholder = attributedPlaceholder
            emailTextField.layer.borderColor = UIColor.red.cgColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.emailTextField.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
                    let placeholderAttributes: [NSAttributedString.Key: Any] = [
                        .foregroundColor: UIColor(named: "AccentColor")!
                    ]
                    let attributedPlaceholder = NSAttributedString(string: "Email", attributes: placeholderAttributes)
                    // Assign the attributed placeholder to the text field
                    self.emailTextField.attributedPlaceholder = attributedPlaceholder
                }
            }
        }
        
        // Display error messages or highlight fields if needed
        if !isValid {
            changepass.textColor = UIColor.red
            sendcode.backgroundColor = UIColor.red
            
            // Shake animation
            let shakeAnimation = CABasicAnimation(keyPath: "position")
            shakeAnimation.duration = 0.07
            shakeAnimation.repeatCount = 4
            shakeAnimation.autoreverses = true
            shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: sendcode.center.x - 10, y: sendcode.center.y))
            shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: sendcode.center.x + 10, y: sendcode.center.y))
            sendcode.layer.add(shakeAnimation, forKey: "shake")
            
            // Delay the execution of code using DispatchQueue
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the color change back to the default or desired color
                UIView.animate(withDuration: 0.3) {
                    self.sendcode.backgroundColor = UIColor(named: "AccentColor") // Replace with the desired background color
                    self.changepass.textColor = UIColor(named: "AccentColor")
                }
                // Remove the shake animation
                self.sendcode.layer.removeAnimation(forKey: "shake")
            }
        }
        
        return isValid
    }
    
    func isValidEmail(_ email: String) -> Bool {
        // Use regular expressions to validate email format
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
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
