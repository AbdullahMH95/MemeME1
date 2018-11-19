//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Abdullah Al-Mahry on 12/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextFieldDelegate
 {

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isEditing {
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setTest(textField: topText, text: "TOP")
        setTest(textField: bottomText, text: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if (sender as! UIBarButtonItem).tag == 0 { // Start Camera
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
        } else { // Open Photo library
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            
            // *From rubric* The chosen image from the camera or the photo album is displayed and scaled properly with AspectFit to fit the device screen.
            imageView.contentMode = .scaleAspectFit
            
            shareButton.isEnabled = true
            picker.dismiss(animated: true, completion: nil)
        }
        else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar
       bottomToolbar.isHidden = true
       topToolbar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        bottomToolbar.isHidden = false
        topToolbar.isHidden = false
        
        return memedImage
    }
    // Leeson 4: 9- Textfield Specifications
    // 4. When a user taps inside a textfield, the default text should clear. This can be accomplished in textFieldDidBeginEditing method. Be sure to remove default text only, not user entered text.
    // Me: I prefer to be place holder but to get fimlier with delgate (as Udacity said) I most implement UITextFieldDelegate delgate.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
    }
    
    // Share Meme and check if can be share or not?
    // now share button is disabled in ViewDidLoad
    @IBAction func shareMeme(_ sender: Any) {
        if imageView.image == nil || bottomText.text == "BOTTOM" || topText.text == "TOP" {
            print("can't be shared")
            return
        }
        else {
            print("can be shared")
            let memedImage: UIImage = generateMemedImage()
            let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            controller.completionWithItemsHandler = {( activityType, completed, returnedItems, activityError ) in
                if completed {
                    self.save()
                }
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func reset(_ sender: Any) {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    func setTest(textField: UITextField, text: String) {
        let memeTextAttributes : [NSAttributedString.Key : Any] = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -3.0
        ]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.textAlignment = .center

    }
    
}

// MEME STRUCT
struct Meme {
    var topText: String!
    var bottomText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
}
