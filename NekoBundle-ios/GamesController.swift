//
//  GamesController.swift
//  NekoBundle-ios
//
//  Created by lab_pk_29 on 24/11/18.
//  Copyright © 2018 Ryandi Widjaja. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class GamesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let URL_GET_DATA = "https://ios.project-tf.xyz/api/games"
    
    @IBOutlet weak var tableGames: UITableView!
    
    var games = [Games]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(URL_GET_DATA).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do{
                        let jsonObject = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                        let gamesarray = jsonObject as? [AnyObject]
                        for gms in gamesarray! {
                            let g = Games(json: gms as! [String: Any])
                            self.games.append(g)
                        }
                        self.tableGames.reloadData()
                    }
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        self.tableGames.reloadData()
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnHistory(_ sender: Any) {
        performSegue(withIdentifier: "storeHistory_segue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableGames
        
        let game: Games
        game=games[indexPath.row]
        cell.labelJudul?.text = game.nama
        cell.labelHarga?.text =  game.harga
        Alamofire.request(game.gambar!).responseImage { response in
            if let image = response.result.value {
                cell.gambarGames?.image = image
            }
        }
        cell.stock = game.stock
        cell.id = game.id
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toDetail"{
            let detailVC = segue.destination as? DetailGamesController
            let cell = sender as? TableGames
            
            if cell != nil && detailVC != nil{
                detailVC?.idGames = cell?.id
            }
        }
        
    }

    
}
