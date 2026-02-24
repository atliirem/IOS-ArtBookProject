//
//  DetailsVC.swift
//  ArtBookProject
//
//  Created by İrem Atlı on 17.02.2026.
//

import UIKit
internal import CoreData

class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var artistText: UITextField!
    
    @IBOutlet weak var yearText: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
        
        
        imageView.isUserInteractionEnabled = true // kullanıcı görsele tıklayabiliyor mu?
        
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage));    imageView.addGestureRecognizer(imageTapRecognizer)
        
    }
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let h = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, view.frame.origin.y == 0 {
            view.frame.origin.y -= h / 2
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
       
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
                
        //Attributes
        
        newPainting.setValue(textField.text!, forKey: "name")
        newPainting.setValue(artistText.text!, forKey: "artist")
        if let year = Int(yearText.text!) {
            newPainting.setValue(year, forKey: "year")
        }
        newPainting.setValue(UUID(), forKey: "id")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        newPainting.setValue(data, forKey: "image")
        
        do {
            try context.save()
        } catch  {
            print("error: \(error.localizedDescription)")
        }
        
        navigationController?.popViewController(animated: true)
        
      
    }
    
}
