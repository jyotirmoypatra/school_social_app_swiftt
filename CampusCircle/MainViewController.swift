//
//  MainViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 29/02/24.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var appNameBtn: UIButton!
    @IBOutlet var topBarSearchIconBtn: UIButton!
    
    
    @IBOutlet var HomeBtn: UIButton!
    @IBOutlet var friendRequestBtn: UIButton!
    @IBOutlet var mySchoolNoticeBtn: UIButton!
    @IBOutlet var myProfileBtn: UIButton!
    @IBOutlet var notificationBtn: UIButton!
    @IBOutlet var moreTabBtn: UIButton!
    
    
    @IBOutlet var ContainerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setCustomView()
        
        HomeBtnPress(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

   
   
    func setCustomView(){
        FontAwesomeUtil.setFontAwesomeIcon(for: topBarSearchIconBtn, iconName: FIcon.SearchIcon, size: 22)
        FontAwesomeUtil.setFontAwesomeIcon(for: HomeBtn, iconName: FIcon.HomeIcon, size: 30)
        FontAwesomeUtil.setFontAwesomeIcon(for: friendRequestBtn, iconName: FIcon.FriendIcon, size: 24)
        FontAwesomeUtil.setFontAwesomeIcon(for: mySchoolNoticeBtn, iconName: FIcon.NoticeIcon, size: 25)
        FontAwesomeUtil.setFontAwesomeIcon(for: myProfileBtn, iconName: FIcon.ProfileIcon, size: 28)
        FontAwesomeUtil.setFontAwesomeIcon(for: notificationBtn, iconName: FIcon.NotificationIcon, size: 25)
        FontAwesomeUtil.setFontAwesomeIcon(for: moreTabBtn, iconName: FIcon.TabMenuIcon, size: 25)
        
    }
    
    @IBAction func topBarSearchBtnPress(_ sender: Any) {
    }
    
    
    @IBAction func HomeBtnPress(_ sender: Any) {
        HomeBtn.setTitleColor(UIColor(hex: "#2688ff"), for: .normal)
        myProfileBtn.setTitleColor(UIColor.white, for: .normal)
        loadView(view: "home")
    }
    
    
    @IBAction func friendRequestBtnPress(_ sender: Any) {
    }
    

    
    @IBAction func mySchoolNoticeBtnPress(_ sender: Any) {
    }
    
    
    @IBAction func myProfileBtnPress(_ sender: Any) {
        myProfileBtn.setTitleColor(UIColor(hex: "#2688ff"), for: .normal)
        HomeBtn.setTitleColor(UIColor.white, for: .normal)
        loadView(view: "profile")
    }
    
    
    @IBAction func notificationBtnPress(_ sender: Any) {
    }
    
    @IBAction func moreTabBtnPress(_ sender: Any) {
    }
    
    
    
    
    func loadView(view : String) {
        
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        var childViewController: UIViewController?
        if view == "home" {
             childViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeFeedViewController") as! HomeFeedViewController
        }else if view == "profile" {
           childViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        }
        
        guard let childVC = childViewController else {
                // Handle the case where the view parameter is not recognized or other error
                return
            }

       addChild(childVC)
       
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
