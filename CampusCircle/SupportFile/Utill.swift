//
//  Utill.swift
//  CampusCircle
//
//  Created by mac-high-13 on 29/02/24.
//
import UIKit
import Foundation
import SystemConfiguration
import MobileCoreServices


extension UIColor {
    convenience init?(hex: String) {
        // Remove any leading # character
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        // Check if the hex string has the correct length
        guard hexSanitized.count == 6 else {
            return nil
        }

        // Convert hex string to an integer
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)

        // Extract red, green, blue components from the integer
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        // Create UIColor object
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

struct FontAwesomeUtil {
    static func setFontAwesomeIcon(for button: UIButton, iconName: String, size: CGFloat) {
        if let font = UIFont(name: "FontAwesome", size: size) {
            button.titleLabel?.font = font
            
            let unicodeScalarValue = Int(iconName, radix: 16) ?? 0
            if let unicodeScalar = UnicodeScalar(unicodeScalarValue) {
                let character = String(unicodeScalar)
                button.setTitle(character, for: .normal)
            }
        }
    }
}

struct FIcon {
    static var SearchIcon:String = "f002"
    static var HomeIcon:String = "f015"
    static var FriendIcon:String = "f0c0"
    static var NoticeIcon:String = "f0ea"
    static var TabMenuIcon:String = "f0c9"
    static var NotificationIcon:String = "f0f3"
    static var ProfileIcon:String = "f007"
}

var WebserviceKey:String = "campuscircle@2024#app"
var BaseUrl : String = "https://d936-103-75-161-74.ngrok-free.app/campuscircle/"
var HostUrl : String = "https://d936-103-75-161-74.ngrok-free.app/"
class Utill: NSObject {
    
    func reachable() -> Bool {
        let hostName = "apple.com"
        if let reachability = SCNetworkReachabilityCreateWithName(nil, hostName) {
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            
            return isReachable && !needsConnection
        } else {
            return false
        }
    }
    
    
    func getRequestJsonData(jsonDict: NSMutableDictionary, apiName: String, appendstr: String, forAction action: String) -> URLRequest? {
        
                let urlString = getUrl(api: apiName, append: appendstr)
        
                guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return nil
                }
        
                var request = URLRequest(url: url)
                request.httpMethod = action
        
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
                    request.httpBody = jsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("Error encoding JSON data: \(error)")
                    return nil
                }
        
        return request
        
    }
    
    func getUrl(api: String, append: String) -> String {
     
        if api == "fetchschoollist"{
            return BaseUrl + api + ".php"
        }else if api == "registerstudent"{
            return BaseUrl + api + ".php"
        }else if api == "login"{
            return BaseUrl + api + ".php"
        }else if api == "post"{
            return BaseUrl + api + ".php"
        }else if api == "fetchpost"{
            return BaseUrl + api + ".php"
        }else if api == "likes"{
            return BaseUrl + api + ".php"
        }
        
        return ""
        
    }
    
    func isValidEmail(EmailAddress: String) -> Bool {
        // Regular expression pattern for a simple email validation
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: EmailAddress)
    }
    
    
    func showAlert(message: String, title: String, controller: UIViewController, haveToPop: Bool, actionTitle: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(
                title: actionTitle,
                style: .cancel
            ) { _ in
                if haveToPop {
                    controller.navigationController?.popViewController(animated: true)
                }
            }
            
            alertController.addAction(okAction)
            controller.present(alertController, animated: true, completion: nil)
        }
    }

    
    
    func compressImage(image: UIImage) -> UIImage? {
        guard let imgData = image.jpegData(compressionQuality: 1.0) else {
            return nil
        }

        print("Size of Image(bytes): \(imgData.count)")

        var actualHeight = image.size.height
        var actualWidth = image.size.width
        var maxHeight: CGFloat = 800.0
        var maxWidth: CGFloat = 1000.0
        var imgRatio = actualWidth / actualHeight
        var maxRatio = maxWidth / maxHeight
        var compressionQuality: CGFloat = 0.5 // 50 percent compression

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                // Adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                // Adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }

        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        if let img = UIGraphicsGetImageFromCurrentImageContext(), let imageData = img.jpegData(compressionQuality: compressionQuality) {
            UIGraphicsEndImageContext()
            print("Size of Image(bytes): \(imageData.count)")
            return UIImage(data: imageData)
        } else {
            UIGraphicsEndImageContext()
            return nil
        }
    }

    // Example usage:
    // let compressedImage = compressImage(yourOriginalImage)

    
    
    
    
    static var activityIndicator: UIActivityIndicatorView?

        static func showActivityIndicator(on view: UIView) {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator?.center = view.center
                activityIndicator?.color = .white
                activityIndicator?.hidesWhenStopped = true
                view.addSubview(activityIndicator!)
            }

            activityIndicator?.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
        }

        static func hideActivityIndicator() {
            activityIndicator?.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
}
