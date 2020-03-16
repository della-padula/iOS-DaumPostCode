//
//  ViewController.swift
//  AddressSearch
//
//  Created by TaeinKim on 2020/03/15.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit

protocol AddressSearchResultDelegate {
    func didSelectAddress(selectedAddress: Address?)
}

class ViewController: UIViewController, AddressSearchResultDelegate {
    @IBOutlet weak var viewForCapture: UIView!
    @IBOutlet weak var searchButton  : UIButton!
    @IBOutlet weak var postCodeLabel : UILabel!
    @IBOutlet weak var jibunLabel    : UILabel!
    @IBOutlet weak var roadLabel     : UILabel!
    
    @IBAction func onClickSearch(_ sender: Any) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "addressSearchVC") as! AddressSearchViewController
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        self.renderViewAsImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private func renderViewAsImage() {
        let renderer = UIGraphicsImageRenderer(size: viewForCapture.bounds.size)
        let image = renderer.image { ctx in
            viewForCapture.drawHierarchy(in: viewForCapture.bounds, afterScreenUpdates: true)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
           //사진 저장 한후
           if let error = error {
               // we got back an error!
            print(error.localizedDescription)
           } else {
                // save
            print("Image Saved")
           }
    }
    
    // Delegate Method
    func didSelectAddress(selectedAddress: Address?) {
        self.postCodeLabel.text = selectedAddress?.postCode ?? "nil"
        self.jibunLabel.text = selectedAddress?.jibunAddr ?? "nil"
        self.roadLabel.text = "\(selectedAddress?.depthOneAddr ?? "nil") \(selectedAddress?.deptTwoAddr ?? "nil") \(selectedAddress?.deptThreeAddr ?? "nil")"
    }
}

