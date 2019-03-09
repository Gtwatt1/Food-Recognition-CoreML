//
//  ViewController.swift
//  Food Recognition CoreML
//
//  Created by Godwin Olorunshola on 09/03/2019.
//  Copyright © 2019 Godwin Olorunshola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var predictedFoodName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didTapCamera(_ sender: Any) {
        getPhoto(source: .camera)

    }
    
    @IBAction func didTapPhoto(_ sender: Any) {
        getPhoto(source: .gallery)
    }
    
    
    func getPhoto(source : PhotoSource){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .gallery:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    // source food101 reference https://github.com/ph1ps/Food101-CoreML/blob/master/Food101Prediction/ViewController.swift
    func processImage(_ image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        let confidence = result.foodConfidence["\(result.classLabel)"]! * 100.0
        let converted = String(format: "%.2f", confidence)
        
        selectedImage.image = image
        predictedFoodName.text = "\(result.classLabel) - \(converted) %"
    }
}


extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        selectedImage.image = image
        processImage(image)
        
    }
    
}

