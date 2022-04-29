//
//  ViewController.swift
//  SongsURLSession
//
//  Created by Mac on 29/04/22.
//

import UIKit

class ItunesSongsViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var songsTableView: UITableView!
    
    //MARK: Global Variable
    var songArray:[SongsModel] = []   // Global Array Created
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        songsTableView.dataSource = self
        songsTableView.delegate = self
        songUrlSession()
        
       //let SongDetailsTableViewCellXib = UINib(nibName: "SongDetailsTableViewCell", bundle: .main)
        songsTableView.register(UINib(nibName: "SongDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "SongDetailsTableViewCell")
    }
    //MARK: URL Session Function
    private func songUrlSession() {
        //1. Create Url as String
        let urlString = "https://itunes.apple.com/search/media=music&entity=song&term=ArjitSingh"
        guard let url = URL(string: urlString) else {
            print("UrlString is Invalid")
            return
        }
        //2. Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //3. Calling WebService Using session
        let session = URLSession(configuration: .default)
        //4.Calling DataTask using this Session
        let dataTask = session.dataTask(with: request) { data, response, error in
            //5.Error Condition for Data
            if error == nil {
                guard let data = data else {
                    print("Data is Nil")
                    return
                }
                print(data)
                do {
                    //6. If Data is Present Get JSON
                    guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                    print("Json data Not Present")
                    return
                }
                    //6.1 Creating only for a Result Array in Dictionary
                    guard let json = json["results"] as? [[String:Any]] else {
                        print("Dictionary does not contain any Result as Key")
                        return
                    }
//                    print(json)
                //7. If JSON is Valid (Create a Model Class) and run For Loop for JSON
                    for songDict in json {
                        let artId = songDict["artistId"] as? Int
                        let artname = songDict["artistname"] as? String
                        let songName = songDict["trackName"] as? String
                        let trackUrl = songDict["trackViewUrl"] as? String
                        
                        let songs = SongsModel(artistId: artId,
                                               artistName: artname,
                                               trackName: songName,
                                               songUrl: trackUrl)
                        //7.1 (Create Global Array) to store this data in a Array
                        self.songArray.append(songs)
                        
                        //7.2 TableView Data to be reloaded in main thread
                        DispatchQueue.main.async {
                            self.songsTableView.reloadData()
                        }
                    }
                    
                } catch {
                    print("JSON Error: \(error.localizedDescription)")
                }
                
            } else {
                print("Error: \(error?.localizedDescription as Any)")
            }
            
        }
        //8. Calling API
        dataTask.resume()
    }
}
//MARK: UITableViewDataSource
extension ItunesSongsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "SongDetailsTableViewCell"
        guard let cell = self.songsTableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? SongDetailsTableViewCell else {
            print("SongDetailsTableViewCell Not Present Or as an Identifier")
            return UITableViewCell()
        }
        
        let songIndex = self.songArray[indexPath.row]
        cell.idLabel.text = "\(songIndex.artistId ?? 0)"
        cell.trackNameLable.text = songIndex.trackName
        cell.artNameLabel.text = songIndex.artistName
        cell.trackUrlLabel.text = songIndex.songUrl
        return cell
    }
}
//MARK: UITableViewDelegate
extension ItunesSongsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
    
}
