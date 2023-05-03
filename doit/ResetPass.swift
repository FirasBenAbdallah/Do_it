//
//  ResetPass.swift
//  doit
//
//  Created by FirasBenAbdallah on 7/4/2023.
//

import UIKit

class ResetPass: UIViewController {

    @IBOutlet var conf: FormTextField!
    @IBOutlet var newpass: FormTextField!
    @IBOutlet var code: FormTextField!
    
    
    @IBAction func showHidePassword(_ sender: UIButton) {
        newpass.isSecureTextEntry.toggle()
            // toggle the isSecureTextEntry property to show/hide the password
            if newpass.isSecureTextEntry {
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            // update the button image to show/hide the password
    }
    
    
    @IBAction func showHideConfPassword(_ sender: UIButton) {
        conf.isSecureTextEntry.toggle()
            // toggle the isSecureTextEntry property to show/hide the password
            if conf.isSecureTextEntry {
                sender.setImage(UIImage(systemName: "eye"), for: .normal)
            } else {
                sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
            // update the button image to show/hide the password
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        let code = Int(code.text!)
        let newpass = newpass.text!
        let conf = conf.text!
        
        let url = URL(string: "http://172.17.4.2:3000/resetPassword")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print(code!)
        print(newpass)
        print(conf)
        let params: [String: Any] = ["code": code!, "password": newpass, "conf": conf]
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        // Do any additional setup after loading the view.
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
