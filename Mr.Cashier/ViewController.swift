//
//  ViewController.swift
//  Mr.Cashier
//
//  Created by Shimaa Hassan on 4/13/19.
//  Copyright © 2019 Shimaa Hassan. All rights reserved.
//

import UIKit
import TesseractOCRSDKiOS
import ImagePicker

struct Product {
    var image: UIImage
    var label: String
}
class ViewController: UIViewController{
    @IBOutlet weak var selectImagesBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calculateBtn: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    let imagePickerController = ImagePickerController()
    var images = [UIImage]()
    var lables = [(String,Double)]()
    var total = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupActivityLoading(vc: self, mainView: view)
//        let current_img = UIImage(named: "im9")
//        img.image = current_img
//        if let tesseract = MGTesseract(language: "eng") {
//            tesseract.image = current_img
//            tesseract.recognize()
//            txtView.text = tesseract.recognizedText
//
//        }
    }

    func setupLayout(){
        selectImagesBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 100)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        imagePickerController.imageLimit = 5
        imagePickerController.delegate = self

        selectImagesBtn.addTarget(self, action: #selector(selectImages), for: .touchUpInside)
        calculateBtn.addTarget(self, action: #selector(processing), for: .touchUpInside)

    }
    
    @objc func selectImages(){
        present(imagePickerController, animated: true, completion: nil)
    }
    @objc func processing(){
        total = 0.0
        priceLabel.text = total.description
        self.lables.removeAll()
//        print(self.images.count)
        for (index,img) in self.images.enumerated(){
        if let tesseract = MGTesseract(language: "eng") {
            tesseract.image = img
            tesseract.recognize()
            let result = tesseract.recognizedText.description.lowercased()
            print(result)
            for (key,val) in dict{
                if result.contains(key) {
                    self.lables.append((key,val))
                    collectionView.reloadData()
                    self.total += val
                    break
                }
            }
        }
            priceLabel.text = total.description
            if self.lables.count != (index + 1){
                self.lables.append(("Not Product",0.0))
            }
    }
    }
}
extension ViewController: ImagePickerDelegate{
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapperDidPress")
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
        self.images = images
        collectionView.reloadData()
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.image.image = #imageLiteral(resourceName: "img_holder")
        cell.image.contentMode = .scaleToFill
        cell.delete.isHidden = true
        cell.image.image = #imageLiteral(resourceName: "img_holder")
        cell.name.text = "Not Product"

        if self.images.count > indexPath.row{
            cell.image.contentMode = .scaleToFill
            cell.image.image = self.images[indexPath.row]
            cell.delete.isHidden = false
            cell.delete.addTargetClosure { (_) in
                self.total -= self.lables[indexPath.row].1
                self.priceLabel.text = self.total.description
                self.images.remove(at: indexPath.row)
                self.lables.remove(at: indexPath.row)
                collectionView.reloadData()
            }
        }
        if self.lables.count > indexPath.row{
            cell.name.text = self.lables[indexPath.row].0.uppercased() + " " + self.lables[indexPath.row].1.description
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row >= self.images.count{
//            present(imagePickerController, animated: true, completion: nil)
//        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    }
}

