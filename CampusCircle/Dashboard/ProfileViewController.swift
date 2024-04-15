//
//  ProfileViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 06/03/24.
//

import UIKit

class ProfileViewController: UIViewController {

    
    
    @IBOutlet var ProfilePictureBtn: UIButton!
    @IBOutlet var UserName: UILabel!
    @IBOutlet var editProfileBtn: UIButton!
    
    @IBOutlet var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileBtn.layer.cornerRadius = 15.0
        editProfileBtn.layer.masksToBounds = true
        logoutBtn.layer.cornerRadius = 15.0
        logoutBtn.layer.masksToBounds = true

        // Do any additional setup after loading the view.
        if let userType = UserDefaults.standard.string(forKey: "user_type") {
            if let storedData = UserDefaults.standard.dictionary(forKey: "user_data") as? [String: String] {
                if userType == "student" {
                    UserName.text = storedData["student_name"]
                }
            }
            
        }
    }
    

    
    
    
    @IBAction func profilePicBtnPress(_ sender: Any) {
    }
    
    @IBAction func editProfileBtnPress(_ sender: Any) {
    }
    
    
    
    @IBAction func logoutBtnPress(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard

        // Create an alert controller
        let alertController = UIAlertController(
            title: "Confirmation",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        // Add a "Cancel" action
        alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))

        // Add a "Confirm" action
        alertController.addAction(UIAlertAction(title: "YES", style: .destructive) { _ in
            // Check if the keys exist in UserDefaults
            if userDefaults.object(forKey: "user_data") != nil && userDefaults.object(forKey: "user_type") != nil {
                // Remove the data for the specific keys
                userDefaults.removeObject(forKey: "user_data")
                userDefaults.removeObject(forKey: "user_type")
                
                // Synchronize UserDefaults to make sure changes are saved
                userDefaults.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    // Optionally, you can set data on wallpaperViewController if needed

                    // Push the view controller onto the navigation stack
                    self.navigationController?.pushViewController(loginViewController, animated: true)
                }
                print("Data for keys 'user_data' and 'user_type' removed successfully.")
            } else {
                print("No data found for one or both of the keys.")
            }
        })

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)

    }
    
}
