//
//  RegisterStudentViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 01/03/24.
//

import UIKit

class RegisterStudentViewController: UIViewController,SelectorPopOverDelegate {

    
    @IBOutlet var NameTextfield: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var SelectSchoolBtn: UIButton!
    @IBOutlet var SetPasswordTextfield: UITextField!
    @IBOutlet var ConfirmPasswordTextfield: UITextField!
    @IBOutlet var classTextField: UITextField!
    @IBOutlet var boardTextfield: UITextField!
    @IBOutlet var RegisterBtn: UIButton!
    @IBOutlet var LoginBtn: UIButton!
    
    var SchoolId:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SchoolId = ""
        // Do any additional setup after loading the view.
        setcustomview()
    }
    
    
    func setcustomview(){
        NameTextfield.layer.cornerRadius = 25.0
        NameTextfield.layer.masksToBounds = true
        
        EmailTextField.layer.cornerRadius = 25.0
        EmailTextField.layer.masksToBounds = true
        
        SelectSchoolBtn.layer.cornerRadius = 25.0
        SelectSchoolBtn.layer.masksToBounds = true
        
        SetPasswordTextfield.layer.cornerRadius = 25.0
        SetPasswordTextfield.layer.masksToBounds = true
        
        boardTextfield.layer.cornerRadius = 25.0
        boardTextfield.layer.masksToBounds = true
        
        classTextField.layer.cornerRadius = 25.0
        classTextField.layer.masksToBounds = true
        
        ConfirmPasswordTextfield.layer.cornerRadius = 25.0
        ConfirmPasswordTextfield.layer.masksToBounds = true
        
        RegisterBtn.layer.cornerRadius = 25.0
        RegisterBtn.layer.masksToBounds = true
        
        LoginBtn.layer.cornerRadius = 25.0
        LoginBtn.layer.masksToBounds = true
    }
    
    
    @IBAction func SelectSchoolBtnPress(_ sender: Any) {
        print("popup")
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
              if let selectorPopUpViewController = storyboard.instantiateViewController(withIdentifier: "SelectorPopUpViewController") as? SelectorPopUpViewController {
                  selectorPopUpViewController.modalPresentationStyle = .overCurrentContext
                  selectorPopUpViewController.delegate=self
                  // Present the view controller modally
                self.present(selectorPopUpViewController, animated: true, completion: nil)
  
              }
    }
    
    
  
    
    
  
    
    
    func didSelectItem(schoolId: String,Name:String){
            SchoolId = schoolId
            SelectSchoolBtn.setTitle(Name, for: .normal)
       
    }

    
    
    @IBAction func RegisterBtnPress(_ sender: Any) {
        print("reg press")
        
        // Trim and check if all text fields have values
        if let name = NameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let email = EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let pass = SetPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let cnfmPass = ConfirmPasswordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let txtClass = classTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
           let board = boardTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) {

            if !name.isEmpty && !email.isEmpty && !pass.isEmpty && !cnfmPass.isEmpty && !txtClass.isEmpty && !board.isEmpty {
                    // All fields have values, proceed with your logic or method
                    // Example: Check if passwords match
                    if pass != cnfmPass {
                        Utill().showAlert(message: "Password Not Match!", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                    }else if !Utill().isValidEmail(EmailAddress: email){
                        Utill().showAlert(message: "Email Not valid!", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                    }else if SchoolId == "" {
                        Utill().showAlert(message: "Please Select School!", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                    }else {
                       
                        let dict = NSMutableDictionary()
                        dict["studentname"] = name
                        dict["studentemail"] = email
                        dict["studentclass"] = txtClass
                        dict["studentboard"] = board
                        dict["studentpassword"] = cnfmPass
                        dict["studentschoolid"] = SchoolId
                        
                        
                       Register_Webservice_call(jsonRequestDict: dict)
                        
                    }
                } else {
                    // At least one field is empty, show an alert
                    Utill().showAlert(message: "Please Fill up all details", title: "", controller: self, haveToPop: false, actionTitle: "OK")
                }
          

        } else {
            Utill().showAlert(message: "Please Fill up all details", title: "", controller: self, haveToPop: false, actionTitle: "OK")
        }

        
    }
    
    
    @IBAction func LoginBtnPress(_ sender: Any) {
        print("login press")
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            // Optionally, you can set data on wallpaperViewController if needed

            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    
    
    
    
    func Register_Webservice_call(jsonRequestDict:NSMutableDictionary) {
        if Utill().reachable() {
            
            Utill.showActivityIndicator(on: self.view)
           
            jsonRequestDict["webservicekey"] = WebserviceKey
    

            let apiName = "registerstudent"
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

                                    self.NameTextfield.text = ""
                                    self.EmailTextField.text = ""
                                    self.classTextField.text = ""
                                    self.SetPasswordTextfield.text = ""
                                    self.ConfirmPasswordTextfield.text = ""
                                    self.classTextField.text = ""
                                    self.boardTextfield.text = ""
                                    self.SelectSchoolBtn.setTitle("Select School", for: .normal)
                                    self.SchoolId = ""
                                    
                                    // Create an OK action
                                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
                                        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                                            // Optionally, you can set data on wallpaperViewController if needed

                                            // Push the view controller onto the navigation stack
                                            self.navigationController?.pushViewController(loginViewController, animated: true)
                                        }
                                    }

                                    // Add the OK action to the alert controller
                                    alertController.addAction(okAction)

                                    // Get the topmost view controller to present the alert
                                    if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
                                        // Present the alert
                                        topViewController.present(alertController, animated: true, completion: nil)
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
