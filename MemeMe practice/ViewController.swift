//
//  ViewController.swift
//  MemeMe practice
//
//  Created by Артем Улько on 03/04/2020.
//  Copyright © 2020 Артем Улько. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
        ] as [NSAttributedString.Key : Any]
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        prepareTextView(textField: topText)
        prepareTextView(textField: bottomText)
        clearUI()
        
        super.viewDidLoad()
    }
    
    func clearUI() {
        shareButton.isEnabled = false
        image.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    func prepareTextView(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.borderStyle = .none
        textField.delegate = self
        textField.textAlignment = .center
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let meme = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [meme] , applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if (success) {
                self.clearUI()
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
        
    }
    
    func updateToolbar(_ state: Bool) {
        toolbar.isHidden = state
        self.navigationController?.setNavigationBarHidden(state, animated: true)
    }
        
    
    func generateMemedImage() -> UIImage {
        
        updateToolbar(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        updateToolbar(false)

        return memedImage
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension ViewController: UINavigationControllerDelegate {
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sender.tag == 2 ? .photoLibrary : .camera
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = textField.tag == 1 ? "TOP" : "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
}
