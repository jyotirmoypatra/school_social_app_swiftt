//
//  HomeFeedViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 06/03/24.
//

import UIKit
import SDWebImage
class HomeFeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PostUploadedDelegate {
   
    private let refreshControl = UIRefreshControl()
    var postArray:[[String:String]] = []
    
    
    
    @IBOutlet var WritePostSection: UIStackView!
    
    @IBOutlet var WritePostSectionHightConstarint: NSLayoutConstraint!
    
    
    
   
    @IBOutlet var WritePostView: UIView!
    @IBOutlet var WritePostBtn: UIButton!
    @IBOutlet var PostTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.tintColor = .white
       refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        PostTableView.refreshControl = refreshControl
        
        
        
        PostTableView.allowsSelection = false
        setUpCustomView()
    }
    @objc func refreshData() {
        FetchPostList_Webservice_Call()
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.refreshControl.endRefreshing()
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        FetchPostList_Webservice_Call()
    }
    
    func setUpCustomView(){
        WritePostView.layer.cornerRadius = 20.0
        WritePostView.layer.borderWidth = 1.5
        WritePostView.layer.borderColor = UIColor.darkGray.cgColor
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return postArray.count
        
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.loader.isHidden = true
        
        
        let dict = postArray[indexPath.row]
        
        cell.postTextView.text = dict["post_text"]
        
        if let text = cell.postTextView.text {
            let fixedWidth = cell.postTextView.frame.size.width
            let newSize = cell.postTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            
            cell.postTextHeightConstaint.constant = newSize.height
            cell.postTextView.isScrollEnabled = false
        }
        cell.profileName.text = dict["username"]
        
        
        if let stringUrl = dict["post_img_url"], !stringUrl.isEmpty {
                if let url = URL(string: (HostUrl + stringUrl)) {
                    cell.loader.isHidden = false
                    cell.loader.startAnimating()

                    cell.postImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png")) { (image, error, cacheType, url) in
                        // Image loading is complete
                        cell.loader.stopAnimating()
                        cell.loader.isHidden = true

                        // Check if there was an error loading the image
                        if error != nil {
                            cell.postImage.image = nil
                            cell.postImageHightConstraint.constant = 0.0
                            cell.postImage.isHidden = true
                        } else {
                            // Update constraints to fit the loaded image
                            cell.postImage.contentMode = .scaleAspectFit
                            cell.postImageHightConstraint.constant = cell.postImage.frame.width / (image?.size.width ?? 1.0) * (image?.size.height ?? 1.0)
                            cell.postImage.isHidden = false
                        }
                        // Trigger layout update
                        cell.contentView.layoutIfNeeded()
                    }
                }
            } else {
                // No image available, hide the image view
                cell.postImage.image = nil
                cell.postImageHightConstraint.constant = 0.0
                cell.postImage.isHidden = true
            }
        cell.postImage.contentMode = .scaleAspectFill
            cell.postImage.clipsToBounds = true
        cell.likeBtn.setTitle(dict["total_like"], for: .normal)
        cell.commentBtn.setTitle("0", for: .normal)

        
        cell.likeBtn.tag = indexPath.row
        
        if let like_click = dict["like_click"]{
            if like_click == "true"{
                cell.likeBtn.tintColor = UIColor(hex: "#2688ff")
            }else if like_click == "false" {
                cell.likeBtn.tintColor = UIColor.white
            }
        }
       
        
        return cell
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Check the contentOffset to determine scrolling direction
        if scrollView.panGestureRecognizer.translation(in: scrollView).y > 0 {
            // Scrolling up, show the view
            UIView.animate(withDuration: 0.3) {
                self.WritePostSection.isHidden = false
                self.WritePostSectionHightConstarint.constant = 40.0
                self.view.layoutIfNeeded()
            }
        } else {
            // Scrolling down, hide the view
            UIView.animate(withDuration: 0.3) {
                self.WritePostSection.isHidden = true
                self.WritePostSectionHightConstarint.constant = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }

    
    
    
    @IBAction func WritePostBtnPress(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
              if let addNewPostViewController = storyboard.instantiateViewController(withIdentifier: "AddNewPostViewController") as? AddNewPostViewController {
                  
                  addNewPostViewController.modalPresentationStyle = .overCurrentContext
                  addNewPostViewController.delegate = self
                self.present(addNewPostViewController, animated: true, completion: nil)
  
              }
    }
    
    
    func FetchPostList_Webservice_Call(){
        if Utill().reachable() {
            
            Utill.showActivityIndicator(on: self.view)
           
            let jsonRequestDict = NSMutableDictionary()
            jsonRequestDict["webservicekey"] = WebserviceKey
            if let userDict = UserDefaults.standard.dictionary(forKey: "user_data"){
                let userid = userDict["id"]
                jsonRequestDict["userId"] = userid
            }

            let apiName = "fetchpost"
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
                                   
                                    self.postArray =  responseDict["post"] as! [[String:String]]
                                    print("post list=>>>>>",self.postArray)
                                    self.PostTableView.reloadData()
                               
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
    
    
    //post upload delegate from AddNewPostViewController
    func PostUploadDone() {
        FetchPostList_Webservice_Call()
    }
    
    
    @IBAction func LikeBtnPress(_ sender: UIButton) {
       
        if let cell = PostTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? PostTableViewCell {
           
            
            let postDict = postArray[sender.tag]
            let totalLike = postDict["total_like"]
            
            
            if let like_click = postDict["like_click"]{
                if like_click == "false"{
                    var updateLike = Int(totalLike!)! + 1
                    cell.likeBtn.setTitle(String(updateLike), for: .normal)
                    cell.likeBtn.tintColor = UIColor(hex: "#2688ff")
                    
                    postArray[sender.tag]["like_click"] = "true"
                    postArray[sender.tag]["total_like"] = String(updateLike)
                }else if like_click == "true"{
                    var updateLike = Int(totalLike!)! - 1
                    cell.likeBtn.setTitle(String(updateLike), for: .normal)
                    cell.likeBtn.tintColor = UIColor.white
                    postArray[sender.tag]["like_click"] = "false"
                    postArray[sender.tag]["total_like"] = String(updateLike)
                }
            }
            
            print("updated array is=>>>",postArray)
            
            if let userDict = UserDefaults.standard.dictionary(forKey: "user_data"),
               let userId = userDict["id"] as? String,
               let userType = UserDefaults.standard.string(forKey: "user_type") {

                let likeJsonDict = NSMutableDictionary()
                likeJsonDict["userid"] = userId
                likeJsonDict["postid"] = postDict["post_id"]
                likeJsonDict["usertype"] = userType
                Like_Webservice_call(jsonRequestDict: likeJsonDict)
            } else {
                print("Error retrieving user data or post data.")
            }

            
           
        }
        
      

    }
    
    
    func Like_Webservice_call(jsonRequestDict:NSMutableDictionary){
        if Utill().reachable() {

            Utill.showActivityIndicator(on: self.view)

            jsonRequestDict["webservicekey"] = WebserviceKey
            print("api request=>",jsonRequestDict)

            let apiName = "likes"
            let request = Utill().getRequestJsonData(jsonDict: jsonRequestDict, apiName: apiName, appendstr: "", forAction: "POST")!

            let sharedSession = URLSession.shared
            let dataTask = sharedSession.dataTask(with: request) { data, response, error in

                DispatchQueue.main.async {
                    Utill.hideActivityIndicator()
                    if error == nil {
                        do {
                            let responseString = String(data: data!, encoding: .utf8)
                             print("Response String", responseString ?? "")

                            if let responseDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                                if let status = responseDict["status"] as? String, status == "success" {

                                    

                            } else {

                            }
                        } else {
                           // Utill().showAlert(message: "Error on response format", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                        }
                    } catch {

                       // Utill().showAlert(message: "Error decoding JSON response", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                    }
                } else {
                   // Utill().showAlert(message: "Something went wrong", title: "Error", controller:self, haveToPop: false, actionTitle: "OK")
                }
            }

            }
            dataTask.resume()
        } else {
            //Utill().showAlert(message: "Check Your network connection and try again", title: "No Internet", controller:self, haveToPop: false, actionTitle: "OK")
        }
    }
}
