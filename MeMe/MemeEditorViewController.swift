//
//  ViewController.swift
//  MeMe
//
//  Created by Tanveer Bashir on 11/27/15.
//  Copyright © 2015 Tanveer Bashir. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- outlets and vars
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareBUtton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomNavBar: UIToolbar!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var fontButton: UIBarButtonItem!
    
    var fontName:[String] = []
    var userSelectedFont:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontPicker.delegate = self
        fontPicker.dataSource = self
        fontPickerState(true)
        shareBUtton.enabled = false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    
        //message template
        let intialMessageTemplate = [
            "Welcome to MeMe","\n",
            "To begin take a picture using camera","\n",
            "or select one from photos","\n",
            "select desired font","\n",
            "Add your MeMe and share it with the world!"].joinWithSeparator("")
       infoLabel.text = intialMessageTemplate
        
        //create system font list and populate pickerView
        fontFinder()
        
        //set default font to HelveticaNeue-CondensedBlack
        userSelectedFont = fontName[53]
        setupTextFields(topTextField, placeholder: "Top", hidden: true)
        setupTextFields(bottomTextField, placeholder: "BOTTOM", hidden: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //shift view when keyboard appears
        navigationController?.setToolbarHidden(true, animated: animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //cancel subscription from NSNotificaiton
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK:- Action methods
    @IBAction func textFieldBeginEditing(sender: UITextField) {
        fontPickerState(true)
        topTextField.text = ""
    }
    
    @IBAction func bottomTextFieldBeginEditing(sender: UITextField) {
        fontPickerState(true)
        bottomTextField.text = ""
    }
    
    //Image from camera
    @IBAction func takeImageFromCamera(sender: UIBarButtonItem) {
        fontPickerState(true)
        fontButton.enabled = false
        infoLabel.hidden = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //Image from Album
    @IBAction func pickImageFromAlbum(sender:
        UIBarButtonItem) {
            fontButton.enabled = false
            infoLabelState(true)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
            fontPickerState(true)
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
                self.infoLabelState(false)
                self.fontPickerState(true)
                self.fontButton.enabled = true
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func cancelMeme(sender: UIBarButtonItem) {
        fontPickerState(true)
        infoLabelState(false)
        resetActions()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectFont(sender: UIBarButtonItem) {
        infoLabelState(true)
        fontPickerState(false)
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
        return true
    }
    
    //Set imageview
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        enableDisableOutlets()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Move current view up as keyboard appears
    func keyboardWillAppear(notification: NSNotification){
        navBarHidden(true)
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyBoardHeight(notification)
        }
    }
    
    //Shift view down when keyboard is dismissed
    func keyboardWillHideNotification(notification: NSNotification){
        navBarHidden(false)
        self.view.frame.origin.y = 0
    }
    
    //get keyboard height
    func getKeyBoardHeight(notification: NSNotification)-> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //subscribe to notification when keyboard appears
    func subscribeToKeyboardNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }

    //unsbscribe to notification
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
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // unhide
        navBarHidden(false)
        return memedImage
    }
    
    func saveMeme(){
        let meme = Meme(tText: topTextField.text!, bText: bottomTextField.text!, oImage: imageView.image!, meme: generateMemedImage())
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func enableDisableOutlets(){
        shareBUtton.enabled = true
        topTextField.hidden = false
        bottomTextField.hidden = false
    }
    
    //intial setup for textField
    func setupTextFields(textField:UITextField, placeholder:String, hidden:Bool){
        let memeTextAtributes = [ NSStrokeColorAttributeName: UIColor.blackColor(), NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name:userSelectedFont, size: 30)!, NSStrokeWidthAttributeName: -3.0]
        textField.delegate = self
        textField.hidden = hidden
        textField.defaultTextAttributes = memeTextAtributes
        textField.text = placeholder
        textField.textAlignment = .Center
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        infoLabelState(false)
        fontButton.enabled = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navBarHidden(state: Bool){
        topNavBar.hidden = state
        bottomNavBar.hidden = state
    }
    
    //MARK:- User font selection
    
    func fontFinder(){
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            let names = UIFont.fontNamesForFamilyName(familyName)
            for name in names {
                fontName.append(name)
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontName.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userSelectedFont = fontName[row]
        setupTextFields(topTextField, placeholder: "Top", hidden: false)
        setupTextFields(bottomTextField, placeholder: "BOTTOM", hidden:false)
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var label = view as! UILabel!
        if view == nil {
            label = UILabel()
            label.backgroundColor = UIColor(red: 91/255, green: 202/255, blue: 255/255, alpha: 1)
        }
        
        let font = fontName[row]
        let attFont = NSAttributedString(string: font, attributes: [NSFontAttributeName:UIFont(name: fontName[row], size: 22.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()])
        label.attributedText = attFont
        return label
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55.0
    }

    func fontPickerState(state:Bool){
        fontPicker.hidden = state
    }
    
    func infoLabelState(state:Bool){
        infoLabel.hidden = state
    }
}


