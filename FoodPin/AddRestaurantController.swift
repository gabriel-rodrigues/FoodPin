//
//  AddRestaurantController.swift
//  FoodPin
//
//  Created by Gabriel Rodrigues on 29/07/17.
//  Copyright © 2017 Gabriel Rodrigues. All rights reserved.
//

import UIKit

class AddRestaurantController: UITableViewController {

    @IBOutlet var photoImagemView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    private var haveHere = true
    private var colorWhenIsSelected: UIColor!
    private var colorWhenIsNotSelected: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        colorWhenIsSelected    = yesButton.backgroundColor
        colorWhenIsNotSelected = noButton.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType    = .photoLibrary
                imagePicker.delegate      = self
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        let nameIsEmpty     = nameTextField.text!.isEmpty
        let typeIsEmpty     = typeTextField.text!.isEmpty
        let locationIsEmpty = locationTextField.text!.isEmpty
        
        
        if nameIsEmpty || typeIsEmpty || locationIsEmpty {
            let alertController = UIAlertController(title: "Oops",
                                                    message: "We can'n proceed because one of the field is blank. Please note that all fields are required",
                                                    preferredStyle: .alert)
            
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            
            alertController.addAction(actionOk)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            self.performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
        }
    }
    
    @IBAction func handlerHaveHere(_ sender: UIButton) {
        
        if sender == yesButton {
            haveHere = true
            yesButton.backgroundColor = colorWhenIsSelected
            noButton.backgroundColor  = colorWhenIsNotSelected
        }
        else {
            haveHere = false
            yesButton.backgroundColor = colorWhenIsNotSelected
            noButton.backgroundColor  = colorWhenIsSelected
        }
    }

}


extension AddRestaurantController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.photoImagemView.image         = selectImage
            self.photoImagemView.contentMode   =  .scaleAspectFill
            self.photoImagemView.clipsToBounds = true
            
            
            let leadingConstraint = NSLayoutConstraint(item: photoImagemView,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: photoImagemView.superview,
                                                       attribute: .leading,
                                                       multiplier: 1,
                                                       constant: 0)
            
            leadingConstraint.isActive = true
            
            
            let trailingContraint = NSLayoutConstraint(item: photoImagemView,
                                                       attribute: .trailing,
                                                       relatedBy: .equal,
                                                       toItem: photoImagemView.superview,
                                                       attribute: .trailing,
                                                       multiplier: 1,
                                                       constant: 0)
            
            trailingContraint.isActive = true
            
            let topContraint = NSLayoutConstraint(item: photoImagemView,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: photoImagemView.superview,
                                                  attribute: .top,
                                                  multiplier: 1,
                                                  constant: 0)
            
            topContraint.isActive = true
            
            let bottomConstraint = NSLayoutConstraint(item: photoImagemView,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: photoImagemView.superview,
                                                      attribute: .bottom,
                                                      multiplier: 1,
                                                      constant: 0)
            
            bottomConstraint.isActive = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddRestaurantController : UINavigationControllerDelegate {
    
}
