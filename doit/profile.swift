//
//  profile.swift
//  doit
//
//  Created by FirasBenAbdallah on 13/4/2023.
//


import UIKit
import SwiftUI

class profile: UIViewController {
    

    @IBAction func swiftButton(_ sender: UIButton) {
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    func setup() {
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)

        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
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
