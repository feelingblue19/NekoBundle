//
//  HistoryStoreController.swift
//  NekoBundle-ios
//
//  Created by lab_pk_23 on 26/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire

class HistoryStoreController: UITableViewController {
    
    
    let URL_GET_DATA = "https://ios.project-tf.xyz/api/transaksi"
    let URL_GET_NAMEBYID = "https://ios.project-tf.xyz/api/games"
    let URL_GET_USERID = "https://ios.project-tf.xyz/api/transaksi/showBuyer/"
    let URL_JSON_GET_USERNAME = "https://ios.project-tf.xyz/api/users/show/"
    
    var transaksi = [TransaksiStore]()
    var key:String = ""
    var user_id_string:String = ""
    var user_id:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        key = UserDefaults.standard.string(forKey: "login_key")!
        
        Alamofire.request(URL_JSON_GET_USERNAME + key).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            //print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization
            if let data = response.result.value {
                print("JSON: \(data)") // serialized json response
                let user = User.init(json: data as! [String : Any])
                self.user_id = user.id
                self.user_id_string = String(user.id)

                print(self.user_id_string)
            }
        }

        Alamofire.request(URL_GET_USERID+user_id_string).responseJSON { response in
            print(request)
            
            switch response.result {
            case .success:
                if let data = response.data {
                    do{
                        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                        let transarray = jsonObject as? [AnyObject]
                        for trans in transarray! {
                            let t = TransaksiStore(json: trans as! [String: Any])
                            self.transaksi.append(t)
                        }
                        self.tableView.reloadData()
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteAll(_ sender: Any) {
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(transaksi)
        return transaksi.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let trans: TransaksiStore
        trans = transaksi[indexPath.row]
        let string_id = String(trans.game_id)
        Alamofire.request(URL_GET_NAMEBYID + string_id, method:.get).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                break
                
            case .failure:
                break
            }
        }

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
