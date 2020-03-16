//
//  AddressSearchViewController.swift
//  AddressSearch
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class AddressSearchViewController: UIViewController, ResultCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tfAddress: UITextField!
    @IBAction func onClickSearch(_ sender: Any) {
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        self.doSearchAddress(keyword: tfAddress.text ?? "", page: 0)
    }
    
    @IBOutlet weak var resultTable: UITableView!
    
    private var resultList = [Address]()
    var delegate: AddressSearchResultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultList.removeAll()
        self.indicator.isHidden = true
        
        self.resultTable.delegate = self
        self.resultTable.dataSource = self
        
        self.resultTable.separatorInset = .zero
        self.resultTable.separatorStyle = .none
    }
    
    func doSearchAddress(keyword: String, page: Int) {
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK c4f8f2260925029707d73a4e2601ac8a"
        ]
        
        let parameters: [String: Any] = [
            "query": keyword,
            "page": page,
            "size": 20
        ]
        
        AF.request("https://dapi.kakao.com/v2/local/search/address.json", method: .get, parameters: parameters, headers: headers)
            .responseJSON(completionHandler: { response in
                self.indicator.isHidden = true
                self.indicator.stopAnimating()
                switch response.result {
                case .success(let value):
                    print(response.result)
                    print("total_count : \(JSON(value)["meta"]["total_count"])")
                    print("is_end : \(JSON(value)["meta"]["is_end"])")
                    print("documents : \(JSON(value)["documents"])")
                    
                    //                if let jsonArray = JSON(value)["stores"].array {
                    //                    for jsonObject in jsonArray {
                    //                        itemArray.append(self.parseStoreData(jsonObject: jsonObject))
                    //                    }
                    //                    completion(.success, itemArray)
                    //                } else {
                    //                    completion(.error, nil)
                    //                }
                    
                    if let addressList = JSON(value)["documents"].array {
                        for item in addressList {
                            
                            let addressName = item["address_name"].string ?? ""
                            let jibunAddress = item["address_name"].string ?? "없음"
                            let roadAddress = item["road_address"].string ?? "없음"
                            let depthOneName = self.generateDeptFirstAddr(addr: item["address"]["region_1depth_name"].string ?? "")
                            let depthTwoName = item["address"]["region_2depth_name"].string ?? ""
                            let depthThreeName = item["address"]["region_3depth_name"].string ?? ""
                            let postCode = (item["address"]["zip_code"].string ?? "").isEmpty ? "우편번호 없음" : item["address"]["zip_code"].string ?? ""
                            
                            self.resultList.append(Address(addressName: addressName, postCode: postCode, roadAddr: roadAddress, jibunAddr: jibunAddress, depthOneAddr: depthOneName, deptTwoAddr: depthTwoName, deptThreeAddr: depthThreeName))
                        }
                    }
                    
                    self.resultTable.reloadData()
                case .failure(let error):
                    print(error)
                }
            })
    }
    
    private func generateDeptFirstAddr(addr: String) -> String {
        switch(addr) {
        case "서울":
            return "서울특별시"
        case "대전", "인천", "부산", "광주", "울산", "대구":
            return "\(addr)광역시"
        case "경기", "제주", "강원":
            return "\(addr)도"
        case "충남":
            return "충청남도"
        case "충북":
            return "충청북도"
        case "경남":
            return "경상남도"
        case "전남":
            return "전라남도"
        case "전북":
            return "전라북도"
        case "경북":
            return "경상북도"
        default:
            return "Unknown"
        }
    }
    
    // Delegate Method
    func didSelectOK(didSelectItem: Address?) {
        print("selected : \(didSelectItem?.addressName ?? "unknown")")
        delegate?.didSelectAddress(selectedAddress: didSelectItem)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell") as! ResultCell
        print(self.resultList[indexPath.row].addressName)
        cell.item     = self.resultList[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}
