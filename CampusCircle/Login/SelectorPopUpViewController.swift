//
//  SelectorPopUpViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 29/02/24.
//

import UIKit



protocol SelectorPopOverDelegate: AnyObject {
    func didSelectItem(schoolId: String ,Name:String)
}


class SelectorPopUpViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    weak var delegate: SelectorPopOverDelegate?
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var CardView: UIView!
    @IBOutlet var SearchTextField: UITextField!
    @IBOutlet var HeadingLabel: UILabel!
    
    
    @IBOutlet var listTableView: UITableView!
    var MasterDataArray: [[String: String]] = []
    var dataArray: [[String: String]] = []
    var filteredArray: [[String: String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        MainView.isUserInteractionEnabled = true
        CardView.layer.cornerRadius = 30.0
        
        SearchTextField.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listTableView.separatorStyle = .none
      
        HeadingLabel.text = "SCHOOL LIST"
        SearchTextField.placeholder = "Search School.."
        
        schoolList_webservice()
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
            // Check if the tap is outside of your specific view
            let location = sender.location(in: CardView)
            if !CardView.bounds.contains(location) {
                // Tapped outside the view, dismiss the view controller
                dismiss(animated: true, completion: nil)
            }
        }
 

    @IBAction func SearchBtnPress(_ sender: Any) {
        var searchText = SearchTextField.text
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Do something with the text while typing
              let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        if searchText.isEmpty {
                dataArray = MasterDataArray
        }else{
            dataArray = MasterDataArray.filter { schoolDict in
                let schoolName = schoolDict["school_name"]?.lowercased() ?? ""
                return schoolName.contains(searchText.lowercased())
            }
        }

                // Reload the table view with the filtered data
                listTableView.reloadData()

        return true // Return true to allow the change, or false to reject it
    }
    
    func schoolList_webservice() {
        if Utill().reachable() {
            
            Utill.showActivityIndicator(on: self.view)
            let jsonRequestDict = NSMutableDictionary()
            jsonRequestDict["webservicekey"] = WebserviceKey
    

            let apiName = "fetchschoollist"
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
                                    self.dataArray = responseDict["schools"] as! [[String : String]]
                                    self.MasterDataArray = responseDict["schools"] as! [[String : String]]
                                    print("school list array=>", self.dataArray)
                                    
                                    self.listTableView.reloadData()
                               
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

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

        return dataArray.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell: SelectorPopUpTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SelectorPopUpTableViewCell", for: indexPath) as! SelectorPopUpTableViewCell
        
        cell.cardView.layer.cornerRadius = 15.0
        cell.cardView.layer.masksToBounds = true
        
        
        if let schoolDict = dataArray[indexPath.row] as? [String: Any] {
            // Now 'schoolDict' is of type [String: Any], and you can safely access its elements
            if let schoolName = schoolDict["school_name"] as? String,
               let schoolAddress = schoolDict["address"] as? String {
                let trimmedSchoolName = schoolName.trimmingCharacters(in: .whitespacesAndNewlines)
                let trimmedSchoolAddress = schoolAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                        
                        cell.schoolName.text = trimmedSchoolName
                        cell.schoolAddress.text = trimmedSchoolAddress
            } else {
                // Handle the case where "school_name" is not a String
                cell.schoolName.text = "??"
                cell.schoolAddress.text = "??"
            }
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
            if let schoolDict = dataArray[indexPath.row] as? [String: Any]{
                if let schoolName = schoolDict["school_name"] as? String,
                   let schoolID = schoolDict["id"] as? String{
                    delegate?.didSelectItem(schoolId: schoolID, Name: schoolName)
                    dismiss(animated: true, completion: nil)
                }
            }
     
        
    }
}
