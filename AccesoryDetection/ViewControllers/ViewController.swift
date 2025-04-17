//
//  ViewController.swift
//  AccesoryDetection
//
//  Created by Akash Tala on 17/04/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var selectedImgView: UIImageView!
    @IBOutlet private weak var isValidImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInitSetup()
    }

    private func doInitSetup() {
        
    }

}

// MARK: Action Methods
extension ViewController {
    @IBAction private func selectImgBtnTapped(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
}

// MARK: Image picker or camera picker delegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async {
                ImageManager.shared.detectAccesories(in: image, completion: { isProper in
                    DispatchQueue.main.async {
                        self.selectedImgView.image = image
                        if isProper {
                            self.isValidImgView.tintColor = .green
                        } else {
                            self.isValidImgView.tintColor = .red
                        }
                    }
                })
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
