//
//  ViewController.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/26/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    var storage : [RepoModel] = []
    var defStorage: [RepoModel] = []
    var filteredStorage = [RepoModel]()
    var service = RepoService()
    let searchController = UISearchController()
    var searchMethod: String = "By Name"
    var refreshControll = UIRefreshControl()
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonPressed: UIButton!
    
    @IBOutlet weak var sortPopButton: UIButton!
    @IBOutlet weak var searchPopupButton: UIButton!

    
    
    func setSortPopButton(){
        let optHandler = {(action: UIAction) in
            self.sortBy(method: action.title)
        }
        sortPopButton.menu = UIMenu(children:
                                        [UIAction(title: "Default"  , state: .on  , handler: optHandler),
                                         UIAction(title: "A - Z"  , handler: optHandler) ,
                                         UIAction(title: "Z - A"   , handler: optHandler),
                                         UIAction(title: "By Source" , handler: optHandler)
                                        ])
        sortPopButton.showsMenuAsPrimaryAction = true
        sortPopButton.changesSelectionAsPrimaryAction = true
    }
    
    func setSearchPopButton(){
        let optHandler = {(action: UIAction) in
            self.searchMethod = action.title
        }
        searchPopupButton.menu = UIMenu(children:
                                        [UIAction(title: "By Name"  , state: .on  , handler: optHandler),
                                         UIAction(title: "By Title"  , handler: optHandler) ,
                                         UIAction(title: "By Source"  , state: .on  , handler: optHandler)
                                        ])
        searchPopupButton.showsMenuAsPrimaryAction = true
        searchPopupButton.changesSelectionAsPrimaryAction = true
    }
    
    override func viewDidLoad(){
        setSortPopButton()
        setSearchPopButton()
        tableView.delegate = self
        tableView.register(UINib(nibName: "RepoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        tableView.dataSource = self
        scroll.contentSize = tableView.contentSize
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        loadTable()
        refreshControll.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControll)
        super.viewDidLoad()
        initSearchController()
        
    }
    @objc func refreshTable(send : UIRefreshControl ){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControll.endRefreshing()
        }
    }
    private func fetchData(completion: @escaping ((Result<[GitRep], RequestError> , Result<BucketData , RequestError>)) -> Void) {
        Task(priority: .background) {
            async let resultGit =  service.getGitData()
            async let resulBit =  service.GetBibBucketData()
            let a = await (resultGit , resulBit)
            completion(a)
            
        }
    }
    
    
    func loadTable(completion: (() -> Void)? = nil){
        fetchData(){
            result1 , result2 in
            switch (result1 , result2){
            case (.success(let git) , .success(let bit)):
                let bitStore = self.fromDtoBitToArray(bitBucketData: bit)
                let gitStore = self.fromDtoGitToArray(gitData: git)
                self.storage += bitStore
                self.storage += gitStore
                Task{
                    for value in 0...self.storage.count - 1 {
                        async let img = self.loadImage(from: URL(string: self.storage[value].picture)!)
                        self.storage[value].image = try await img
                        
                        self.tableView.reloadData()
                    }
                    
                }
                self.defStorage = self.storage
                self.tableView.reloadData()
                
                
                
            case (.failure(let error), _):
                self.showModal(title: "Error", message: error.customMessage)
            case (_, .failure(let error)):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
        
    }
    
    
    //засунуть в extension
    func fromDtoBitToArray(bitBucketData: BucketData)->[RepoModel]{
        var models : [RepoModel] = []
        for value in 0...(bitBucketData.values.count - 1){
            
            let title = bitBucketData.values[value].title
            let name = bitBucketData.values[value].owner.dispName
            let description = bitBucketData.values[value].description
            let picture =  bitBucketData.values[value].owner.links.avatar.href
            let source = "BitBucket"
            let htmlURL = bitBucketData.values[value].owner.links.html?.href ?? "No link to HTML URL"
            let type = bitBucketData.values[value].owner.type
            
            var image: UIImage?
            Task{
                image =  try await loadImage(from:URL(string: picture)!)
                
            }
            let model = RepoModel(name: name, title: title, description: description, picture: picture, source: source, htmlURL: htmlURL, type: type , image: image)
            models.append(model)
        }
        
        return models}
    //засунуть в extension
    func fromDtoGitToArray(gitData: [GitRep])->[RepoModel]{
        var models : [RepoModel] = []
        for value in gitData{
            let title = value.title
            let name = value.owner.name ?? "Anonymus"
            let description = value.description ?? ""
            let picture =  value.owner.avatarUrl
            let source = "GitHub"
            let htmlURL = value.htmlUrl
            let type = value.owner.type
            var image: UIImage?
            Task{
                image =  try await loadImage(from:URL(string: picture)!)
                
            }

            let model = RepoModel(name: name, title: title, description: description, picture: picture, source: source, htmlURL: htmlURL, type: type , image: image)

            models.append(model)
        }
        return models
    }
    
    
    func loadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
    
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



extension ViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive){
            return filteredStorage.count
        }
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ReusableCell" , for: indexPath) as! RepoCellTableViewCell
        if (searchController.isActive){
            cell.nameLabel.text  = filteredStorage[indexPath.row].title
            cell.descriptionLabel.text = filteredStorage[indexPath.row].source
            
            cell.fromLabel.text = filteredStorage[indexPath.row].source
            if let img = filteredStorage[indexPath.row].image {
                cell.userImage.image = img
            }
            
        }else if (sortPopButton.titleLabel?.text != "Default"){
            cell.nameLabel.text  = defStorage[indexPath.row].title
            cell.descriptionLabel.text = defStorage[indexPath.row].source
            
            cell.fromLabel.text = defStorage[indexPath.row].source
            if let img = defStorage[indexPath.row].image {
                cell.userImage.image = img
            }
        }
        else{
            cell.nameLabel.text  = storage[indexPath.row].title
            cell.descriptionLabel.text = storage[indexPath.row].source
            
            cell.fromLabel.text = storage[indexPath.row].source
            if let img = storage[indexPath.row].image {
                cell.userImage.image = img
            }
            
        }
        return cell}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "cellInfo", sender: storage[indexPath.row])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellInfo" {
            let destinationVc = segue.destination as! ViewCellInfo
            destinationVc.data = sender as? RepoModel
        }
    }
    
}
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func filterForSearch(searchString: String){
        filteredStorage  = storage.filter{ repoModel in
            if searchController.searchBar.text != ""{
                var searchMatch :Bool  = false
                switch searchMethod{
                case "By Name" :
                    searchMatch = repoModel.name.lowercased().contains(searchString.lowercased())
                case "By Title" :
                    searchMatch = repoModel.title.lowercased().contains(searchString.lowercased())
                    print("first")
                case "By Source":
                    searchMatch = repoModel.source.lowercased().contains(searchString.lowercased())
                    print("second")
                default:
                    searchMatch = repoModel.title.lowercased().contains(searchString.lowercased())
                    print("default")
                }
                
                return searchMatch
            }
            return true
        }
        
        tableView.reloadData()
        
    }
    
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        print("Was called updateSearchResults")
        filterForSearch(searchString: searchText)
    }
}
extension ViewController {
    func sortBy(method: String){
        switch method{
        case "A - Z" :
            defStorage = storage.sorted(by: {$0.title < $1.title})
        case "Z - A" :
            defStorage = storage.sorted(by: {$0.title > $1.title})
        case "By Source":
            defStorage = storage.sorted(by:  {$0.source <= $1.source })
        case "Default" :
            defStorage = storage
        default:
            filteredStorage = storage
        }
        
    }
}
