//
//  LoginViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 29/02/24.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var LoginBtn: UIButton!
    @IBOutlet var CreateAccountBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpCustomView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let storedData = UserDefaults.standard.dictionary(forKey: "user_data") as? [String: String] {

            let autoLogindict = NSMutableDictionary()
            autoLogindict["email"] = storedData["student_email"]
            autoLogindict["password"] = storedData["student_password"]
            Login_Webservice_call(jsonRequestDict: autoLogindict)
            
        }
    }
    
    func setUpCustomView(){
        EmailTextField.layer.cornerRadius = 25.0
        EmailTextField.layer.masksToBounds = true
        
        PasswordTextField.layer.cornerRadius = 25.0
        PasswordTextField.layer.masksToBounds = true
        
        LoginBtn.layer.cornerRadius = 25.0
        LoginBtn.layer.masksToBounds = true
        
        CreateAccountBtn.layer.cornerRadius = 25.0
        CreateAccountBtn.layer.masksToBounds = true
    }
    
    
    
    @IBAction func LoginBtnPress(_ sender: Any) {
        if let email = EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let pass = PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines){

                if !email.isEmpty && !pass.isEmpty  {
                   
                    if !Utill().isValidEmail(EmailAddress: email){
                        Utill().showAlert(message: "Email Not valid!", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                    }else {
                       
                        let dict = NSMutableDictionary()
                        dict["email"] = email
                        dict["password"] = pass
                        
                       Login_Webservice_call(jsonRequestDict: dict)
                        
                    }
                } else {
                    // At least one field is empty, show an alert
                    Utill().showAlert(message: "Please Fill up all details", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                }
          

        } else {
            Utill().showAlert(message: "Please Fill up all details", title: "", controller: self, haveToPop: false, actionTitle: "OK")
        }
    }
    
    
    @IBAction func ForgotPassBtnPress(_ sender: Any) {
    }
    
    
    @IBAction func CreateNewAccountPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        if let registrationViewController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController {
            // Optionally, you can set data on wallpaperViewController if needed

            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(registrationViewController, animated: true)
        }
    }
    
    
    
    
    
    
    
    func Login_Webservice_call(jsonRequestDict:NSMutableDictionary) {
        if Utill().reachable() {
            
            Utill.showActivityIndicator(on: self.view)
           
            jsonRequestDict["webservicekey"] = WebserviceKey
    

            let apiName = "login"
            let request = Utill().getRequestJsonData(jsonDict: jsonRequestDict, apiName: apiName, appendstr: "", forAction: "POST")!

            let sharedSession = URLSession.shared
            let dataTask = sharedSession.dataTask(with: request) { data, response, error in
                
                DispatchQueue.main.async {
                    Utill.hideActivityIndicator()
                    if error == nil {
                        do {
                            let responseString = String(data: data!, encoding: .utf8)
                            // print("Response String", responseString ?? "")
                            
                            if let responseDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                if let status = responseDict["status"] as? String, status == "success" {
                                    let alertController = UIAlertController(title: "Success", message: "Register Successfully", preferredStyle: .alert)

                                    self.EmailTextField.text = ""
                                    self.PasswordTextField.text = ""
                                   
                                    let userdata = responseDict["data"] as!  [String : String];
                                    let user_type = responseDict["user_type"] as! String;
                                    
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(user_type, forKey: "user_type")
                                    userDefaults.set(userdata, forKey: "user_data")
                                    userDefaults.synchronize()

                                    let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                                    if let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                                        // Optionally, you can set data on wallpaperViewController if needed

                                        // Push the view controller onto the navigation stack
                                        self.navigationController?.pushViewController(mainViewController, animated: true)
                                    }
                                    
                               
                            } else {
                                
                                Utill().showAlert(message: responseDict["message"] as! String, title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                            }
                        } else {
                            Utill().showAlert(message: "Error on response format", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                        }
                    } catch {
                        
                        Utill().showAlert(message: "Error decoding JSON response", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                    }
                } else {
                    Utill().showAlert(message: "Something went wrong", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                }
            }

            }
            dataTask.resume()
        } else {
            Utill().showAlert(message: "Check Your network connection and try again", title: "No Internet", controller:self, haveToPop: false, actionTitle: "OK")
        }
    }
   
}
