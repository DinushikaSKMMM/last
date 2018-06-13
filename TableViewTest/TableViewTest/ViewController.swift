//
//  ViewController.swift
//  TableViewTest
//
//  Created by MDL on 6/13/18.
//  Copyright © 2018 fit. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
  
    @IBOutlet weak var userTable: UITableView!
    var fectchUserDetails = [getData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        userTable.dataSource = self
        parseData()
        searchBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func searchBar(){
        let searchBar = UISearchBar()
        
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        searchBar.tintColor = UIColor.lightGray
        searchBar.scopeButtonTitles = ["name","username"]
        self.userTable.tableHeaderView = searchBar
    }
    
    func searchBar(_searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText == "" {
            parseData()
        }
        else{
            if _searchBar.selectedScopeButtonIndex == 0{
                fectchUserDetails = fectchUserDetails.filter({(getData)-> Bool in
                    return getData.name.lowercased().contains(searchText.lowercased())
                    
                })
            }
            else{
                fectchUserDetails = fectchUserDetails.filter({(getData)->Bool in return getData.username.lowercased().contains(searchText.lowercased())})
                
            }
        }
        self.userTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return fectchUserDetails.count
    }
    
  
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = userTable.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = fectchUserDetails[indexPath.row].name
        cell?.detailTextLabel?.text = fectchUserDetails[indexPath.row].username
        return cell!
    }
    
    func parseData(){
        
        fectchUserDetails = []
        
        let url = "https://jsonplaceholder.typicode.com/users/"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let Configeration = URLSessionConfiguration.default
        let session = URLSession(configuration: Configeration, delegate:nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if(error != nil){
                print("Error")
            }else{
                do{
                    let fecthData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    //print(fecthData)
                    for eachfectchUserDetails in fecthData {
                        let eachFechData = eachfectchUserDetails as! [String : Any]
                        let name = eachFechData["name"] as! String
                        let username = eachFechData["username"] as! String
                      //   let suite = eachFechData["suite"] as! String
                        
                        self.fectchUserDetails.append(getData(name: name, username: username))
                     
                    }
                    //print(self.fectchUserDetails)
                    self.userTable.reloadData()
                }
                catch{
                    print("eroor 2")
                }
            }
        }
       task.resume()
    }

class getData {
    var name : String = ""
    var username : String = ""
    //var suite : String = ""

    init(name: String, username: String ){
        self.name = name
        self.username = username
      //  self.suite = suite
    }
}

}
