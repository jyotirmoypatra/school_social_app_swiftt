//
//  RegisterTeacherViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 04/03/24.
//

import UIKit

class RegisterTeacherViewController: UIViewController,SelectorPopOverDelegate {

    
    @IBOutlet var teacherNameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var selectSchoolBtn: UIButton!
    @IBOutlet var subjextTxtField: UITextField!
    @IBOutlet var passTxtField: UITextField!
    @IBOutlet var confirmPassTxtField: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var RegisterBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setcustomview()
    }
    func setcustomview(){
        teacherNameTxtField.layer.cornerRadius = 25.0
        teacherNameTxtField.layer.masksToBounds = true
        
        emailTxtField.layer.cornerRadius = 25.0
        emailTxtField.layer.masksToBounds = true
        
        selectSchoolBtn.layer.cornerRadius = 25.0
        selectSchoolBtn.layer.masksToBounds = true
        
        subjextTxtField.layer.cornerRadius = 25.0
        subjextTxtField.layer.masksToBounds = true
        
        passTxtField.layer.cornerRadius = 25.0
        passTxtField.layer.masksToBounds = true
        
        confirmPassTxtField.layer.cornerRadius = 25.0
        confirmPassTxtField.layer.masksToBounds = true
        
        loginBtn.layer.cornerRadius = 25.0
        loginBtn.layer.masksToBounds = true
        
        RegisterBtn.layer.cornerRadius = 25.0
        RegisterBtn.layer.masksToBounds = true
        
     
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    @IBAction func selectSchoolBtnPress(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
              if let selectorPopUpViewController = storyboard.instantiateViewController(withIdentifier: "SelectorPopUpViewController") as? SelectorPopUpViewController {
                  selectorPopUpViewController.modalPresentationStyle = .overCurrentContext
                  selectorPopUpViewController.delegate=self
                  // Present the view controller modally
                self.present(selectorPopUpViewController, animated: true, completion: nil)
  
              }
    }
    
    
    
    @IBAction func RegisterBtnPress(_ sender: Any) {
        print("reg teacher")
    }
    
    @IBAction func loginBtnPress(_ sender: Any) {
        print("login teacher")
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        if let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            // Optionally, you can set data on wallpaperViewController if needed

            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
    
    func didSelectItem(schoolId: String,Name:String){
       
            selectSchoolBtn.setTitle(Name, for: .normal)
       
    }
}
