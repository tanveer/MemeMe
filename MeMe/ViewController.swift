//
//  ViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/27/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self
        bottomTextField.delegate = self
        let memeTextAtributes = [ NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!, NSStrokeWidthAttributeName: -3.0]
        
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAtributes
        topTextField.textAlignment = .Center
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAtributes
        bottomTextField.textAlignment = .Center
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //shift view down when keyboard is dismissed
        subscribToKeyboardWillHideNotification()
        
        //shift view up when keyboard appears
        subscribToKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - clear text field as editing begins
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        topTextField.text = ""
    }
    
    @IBAction func bottomTextFieldBeginEditing(sender: UITextField) {
        bottomTextField.text = ""
    }
    
    // hide keyboard when done editing
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    //MARK: - Set imageview
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - Image from camera
    
    @IBAction func takeImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Image from Album
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Move current view up as keyboard appears
    
    func keyboardWillAppear(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    //MARK:- Shift view down when keyboard is dismissed
    func keyboardWillHideNotification(){
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    //get keyboard height
    func getKeyBoardHeight(notification: NSNotification)-> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //subscrib to notification when keyboard appears
    func subscribToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    //subscrib to nitification when keyboard dismissed
    func subscribToKeyboardWillHideNotification(){
        unsubscribeFromKeyboardNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //unsbscrib to notification
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
}

