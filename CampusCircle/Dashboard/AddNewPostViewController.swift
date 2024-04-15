//
//  AddNewPostViewController.swift
//  CampusCircle
//
//  Created by mac-high-13 on 06/03/24.
//

import UIKit

protocol PostUploadedDelegate: AnyObject {
    func PostUploadDone()
}

class AddNewPostViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: PostUploadedDelegate?
    
    @IBOutlet var MainView: UIView!
    @IBOutlet var postBtn: UIButton!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postTextViewHightConstraint: NSLayoutConstraint!
    @IBOutlet var placeHolderLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var postPhotoHeightConstaint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    @IBOutlet var postImgCrossBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postBtn.layer.cornerRadius = 10.0
        placeHolderLabel.isHidden = !postTextView.text.isEmpty
        updatePostButtonState()
        
        // Set up the image picker
        postImgCrossBtn.isHidden = true
        
       
     
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeight()
        placeHolderLabel.isHidden = !postTextView.text.isEmpty
        updatePostButtonState()
    }
    
    // Function to update the height constraint based on the text content
    func updateTextViewHeight() {
        // You can adjust these values as needed
        let minHeight: CGFloat = 80
        
        
        // Calculate the height required for the text content
        let newSize = postTextView.sizeThatFits(CGSize(width: postTextView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let newHeight = max(minHeight, newSize.height)
        
        
        // Update the height constraint
        postTextViewHightConstraint.constant = newHeight
        
        // Optionally, you can animate the constraint change for a smooth transition
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updatePostButtonState() {
        let isTextViewEmpty = postTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isImageViewEmpty = postImageView.image == nil
        let buttonBackgroundColor: UIColor
        if isTextViewEmpty && isImageViewEmpty {
            buttonBackgroundColor = UIColor(hex: "#303030")! // Set color when both are empty
            } else {
                buttonBackgroundColor = UIColor.blue // Set color when either the text or image is present
            }

        postBtn.backgroundColor = buttonBackgroundColor
       
    }
    
    
    
    @IBAction func backBtnPress(_ sender: Any) {
        if !postTextView.text.isEmpty ||  postImageView.image != nil {
            let alert = UIAlertController(title: "Alert", message: "You have added something. Are you sure you want to back?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Back", style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    @IBAction func cameraBtnPress(_ sender: Any) {
        presentImagePicker(with: .camera)
    }
    
    @IBAction func galleryBtnPress(_ sender: Any) {
        presentImagePicker(with: .photoLibrary)
    }
    
    func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        // Check if the selected source type is available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Display an alert if the selected source type is not available
            showSourceNotAvailableAlert()
        }
    }
    func showSourceNotAvailableAlert() {
        let alert = UIAlertController(title: "Source Not Available", message: "The selected source is not accessible on this device.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            pickedImage = originalImage
        }
        
        if let selectedImage = pickedImage {
            
            
            let compressedImage = Utill().compressImage(image: selectedImage)
            
            
            
            
            // Set the picked image to your UIImageView
            postImageView.image = compressedImage
            let aspectRatio = compressedImage!.size.width / compressedImage!.size.height
            let newHeight = postImageView.frame.width / aspectRatio
            postPhotoHeightConstaint.constant = newHeight
            postImgCrossBtn.isHidden = false
            updatePostButtonState()
          
        }
        
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method called when the user cancels image picking
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the image picker
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postImgCrossBtnPress(_ sender: Any) {
        postImgCrossBtn.isHidden = true
        postImageView.image = nil
        postPhotoHeightConstaint.constant = 200
        updatePostButtonState()
        // Optionally, animate the constraint change for a smooth transition
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func postBtnPress(_ sender: Any) {
        if !postTextView.text.isEmpty ||  postImageView.image != nil {
           let jsonDict = NSMutableDictionary()
            if let storedData = UserDefaults.standard.dictionary(forKey: "user_data") as? [String: String],
               let userType = UserDefaults.standard.string(forKey: "user_type") {
               print("user data=>",storedData)
               print("user type=>",userType)
                
                
                
                
                jsonDict["usertype"] = userType
                jsonDict["userid"] = storedData["id"]
                jsonDict["posttext"] = postTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                if let image = postImageView.image {
                    if let base64String = convertImageToBase64(image: image) {
                        jsonDict["imgbase64"] = base64String
                    } else {
                        jsonDict["imgbase64"] = ""
                    }
                } else {
                    jsonDict["imgbase64"] = ""
                }
                
            }
            
            PostAdd_Webservice_call(jsonRequestDict: jsonDict)
            
        }
    }
    
    func convertImageToBase64(image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            return imageData.base64EncodedString(options: .lineLength64Characters)
        }
        return nil
    }
    
    
    func PostAdd_Webservice_call(jsonRequestDict:NSMutableDictionary) {
        if Utill().reachable() {
            
            Utill.showActivityIndicator(on: self.MainView)
           
            jsonRequestDict["webservicekey"] = WebserviceKey
    

            let apiName = "post"
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
                                                                     
                                    self.postTextView.text = ""
                                    self.postImgCrossBtn.isHidden = true
                                    self.postImageView.image = nil
                                    self.postPhotoHeightConstaint.constant = 200
                                    self.updatePostButtonState()
                                    // Optionally, animate the constraint change for a smooth transition
                                    UIView.animate(withDuration: 0.3) {
                                        self.view.layoutIfNeeded()
                                    }
                                    
                                    self.delegate?.PostUploadDone()
                                    self.dismiss(animated: true, completion: nil)
                               
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
