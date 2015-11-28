//
//  ViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/27/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK:- outlets and vars
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareBUtton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var infoLabel: UILabel!
    
    var memed:Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareBUtton.enabled = false
        setupTextFields()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let intialMessageTemplate = [
            "Welcome to MeMe","\n",
            "To begin take a picture using camera","\n",
            "or select one from photos","\n",
            "Add your MeMe and share it with the world!"].joinWithSeparator("")
        infoLabel.text = intialMessageTemplate
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //shift view when keyboard appears
        subscribToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Action methods
    
    //clear text field as editing begins
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        topTextField.text = ""
    }
    
    @IBAction func bottomTextFieldBeginEditing(sender: UITextField) {
        bottomTextField.text = ""
    }
    
    //Image from camera
    @IBAction func takeImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Image from Album
    @IBAction func pickImageFromAlbum(sender:
        UIBarButtonItem) {
            infoLabel.hidden = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let activityItem = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [activityItem], applicationActivities:nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.saveMeme()
                self.resetActions()
                self.dismissViewControllerAnimated(true, completion:  nil)
                self.infoLabel.hidden = false
            }
        }
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        resetActions()
    }
    
    //MARK:- Helper methods
    
    func resetActions(){
        imageView.image = nil
        topTextField.hidden = true
        bottomTextField.hidden = true
        shareBUtton.enabled = false
    }
    
    // hide keyboard when done editing
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(true)
        navBarHidden(false)
        return false
    }
    
    //MARK: - Set imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        enableDisableOutlets()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK:- Move current view up as keyboard appears
    func keyboardWillAppear(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
           navBarHidden(true)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification", name: UIKeyboardWillHideNotification, object: nil)
    }

    //unsbscrib to notification
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    //generate meme image
    func generateMemedImage() -> UIImage{
        //hide tool and navbar
        navBarHidden(true)
        
        //capture meme
        navigationController?.hidesBarsWhenKeyboardAppears = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // unhide
        navBarHidden(false)
        return memedImage
    }
    
    func saveMeme(){
        memed = Meme(tText: topTextField.text!, bText: bottomTextField.text!, oImage: imageView.image!, meme: generateMemedImage())
    }
    
    func enableDisableOutlets(){
        shareBUtton.enabled = true
        topTextField.hidden = false
        bottomTextField.hidden = false
    }
    
    //intial setup for textFields
    func setupTextFields(){
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.hidden = true
        bottomTextField.hidden = true
        let memeTextAtributes = [ NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!, NSStrokeWidthAttributeName: -3.0]
        topTextField.text = "TOP"
        topTextField.defaultTextAttributes = memeTextAtributes
        topTextField.textAlignment = .Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.defaultTextAttributes = memeTextAtributes
        bottomTextField.textAlignment = .Center
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        infoLabel.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navBarHidden(state: Bool){
        topNavBar.hidden = state
        bottomNavBar.hidden = state
    }
}


