//
//  RegistrationViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 29/02/24.
//

import UIKit

class RegistrationViewController: UIViewController {
   
    @IBOutlet var TeacherTabView: UIView!
    @IBOutlet var StudentTabView: UIView!
    @IBOutlet var teacherTabBtn: UIButton!
    @IBOutlet var studentTabBtn: UIButton!
    @IBOutlet var ContainerView: UIView!
    @IBOutlet var studentTickImag: UIImageView!
    @IBOutlet var teacherTickImg: UIImageView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var fillupheading: UILabel!
    
    @IBOutlet var containerHeightConstaint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        studentTickImag.isHidden = true
        teacherTickImg.isHidden = true
        fillupheading.isHidden = true
        
        TeacherTabView.layer.cornerRadius = 30.0
        TeacherTabView.layer.masksToBounds = true
        StudentTabView.layer.cornerRadius = 30.0
        StudentTabView.layer.masksToBounds = true
       
    }
    
    
    @IBAction func TeacherTabPress(_ sender: Any) {
        loadView(view: "teacher")
        studentTickImag.isHidden = true
        teacherTickImg.isHidden = false
        fillupheading.text = "Fill The Below Teacher Details"
        fillupheading.isHidden = false
    }
    
    
    @IBAction func StudentTabPress(_ sender: Any) {
        loadView(view: "student")
        studentTickImag.isHidden = false
        teacherTickImg.isHidden = true
        fillupheading.text = "Fill The Below Student Details"
        fillupheading.isHidden = false
    }
    
     func loadView(view : String) {
         
         for child in children {
             child.willMove(toParent: nil)
             child.view.removeFromSuperview()
             child.removeFromParent()
         }
         var childViewController: UIViewController?
         if view == "student" {
              childViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterStudentViewController") as! RegisterStudentViewController
         }else if view == "teacher" {
             childViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterTeacherViewController") as! RegisterTeacherViewController
         }
         
         guard let childVC = childViewController else {
                 // Handle the case where the view parameter is not recognized or other error
                 return
             }

        addChild(childVC)
         containerHeightConstaint.constant = childVC.view.frame.height
         // Add the child view controller's view to the container view
         ContainerView.addSubview(childVC.view)
         childVC.view.frame = ContainerView.bounds
         childVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         childVC.view.translatesAutoresizingMaskIntoConstraints = true
         // Notify the child view controller that it has been added to the parent
         //scrollview.contentInset.bottom = childVC.view.frame.height
         childVC.didMove(toParent: self)
         
       
         
         
    }
    
    
}
