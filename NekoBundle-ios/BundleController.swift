//
//  BundleController.swift
//  NekoBundle-ios
//
//  Created by Lab_PK_20 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BundleController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL_GET_DATA = "https://ios.project-tf.xyz/api/bundle"

    @IBOutlet var tableBundle: UITableView!
    
    var bundles = [Bundle]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(URL_GET_DATA).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do{
                        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                        let bundlesarray = jsonObject as? [AnyObject]
                        for bndl in bundlesarray! {
                            let b = Bundle(json: bndl as! [String: Any])
                            self.bundles.append(b)
                        }
                        self.tableBundle.reloadData()
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        self.tableBundle.reloadData()
        
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bundles.count
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableBundle
    
        let bundle: Bundle
        bundle=bundles[indexPath.row]
        print(bundle)
        cell2.labelNama?.text = bundle.nama
        cell2.labelHarga?.text =  bundle.harga
        Alamofire.request(bundle.gambar!).responseImage { response in
            if let image = response.result.value {
                cell2.gambarBundle.image = image
            }
        }
        cell2.stock = bundle.stock
        cell2.idBundle = bundle.id
        return cell2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toDetailBundle"{
            let detailVC = segue.destination as? DetailBundleController
            let cell = sender as? TableBundle
            
            if cell != nil && detailVC != nil{
                detailVC?.idBundle = cell?.idBundle
            }
            else{
                print("error")
            }
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnHistory(_ sender: Any) {
        performSegue(withIdentifier: "bundleHistory_segue", sender: nil)
    }
    
}
