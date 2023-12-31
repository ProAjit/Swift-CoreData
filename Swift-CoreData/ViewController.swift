//
//  ViewController.swift
//  Swift-CoreData
//
//  Created by Ajit Satarkar on 22/11/23.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmailId: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = DatabaseManager.shared.persistentContainer.viewContext
        var users : [UserMetadata] = []
        do {
            users = try context.fetch(UserMetadata.fetchRequest())
            for user in users {
                print(user.email!)
            }
        } catch {
            print("User fetch failed")
        }
    }
    
    @IBAction private func hideKeyBoard(control : UIControl) {
        self.view.endEditing(true)
    }

    @IBAction private func registerButtonClicked() {
        
        guard let userName = self.txtName.text, !userName.isEmpty else {
            self.showAlert("Missing user name")
            return
        }
        
        guard let userEmail = self.txtEmailId.text, !userEmail.isEmpty else {
            self.showAlert("Missing email")
            return
        }
        
        guard let userPasword = self.txtPassword.text, !userPasword.isEmpty else {
            self.showAlert("Missing password ")
            return
        }
        
        let context = DatabaseManager.shared.persistentContainer.viewContext
        
        let userData = UserMetadata(context: context)
        userData.name = userName
        userData.email = userEmail
        userData.password = userPasword
        
        do {
            try context.save()
            self.confirmDataSaved()
        } catch {
            print("User entry failed:", error)
        }
        
        var users : [UserMetadata] = []
        do {
            users = try context.fetch(UserMetadata.fetchRequest())
            for user in users {
                print("\(String(describing: user.name))")
            }
        } catch {
            print("User fetch failed")
        }
    }
    
    private func confirmDataSaved() {
        self.txtName.text = ""
        self.txtEmailId.text = ""
        self.txtPassword.text = ""
        self.showAlert("Data saved to core data base")
    }

}



extension ViewController {
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
