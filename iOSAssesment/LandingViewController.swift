//
//  ViewController.swift
//  iOSAssesment
//
//  Created by Mukesh Sharma on 28/02/22.
//

import UIKit

class LandingViewController : UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var bookArray: [Book] = []
    let bookSearch = BookSearch()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = createMessageLabel(message : "Start Your Search")
    }
    
    // It Returns a UILabel to display on tableview cell
    func createMessageLabel(message : String) -> UILabel{
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textAlignment = .center
        return messageLabel
    }

    //This function search book based upon title returns the parsed JSON
   @IBAction func searchBookAction(){
        bookSearch.searchBooks(keyword: searchBar.text!,
    emptyCompletion: {
    tableView.backgroundView = createMessageLabel(message : "Start Your Search")
    bookArray = []
    tableView.reloadData()
    }, searchCompletion: {[weak self] object in
        self?.bookArray = object
    if(self?.bookArray.count == 0) {
        let message = "No result found for " + (self?.searchBar.text ?? "")
        self?.tableView.backgroundView = self?.createMessageLabel(message : message)
    }
    else {
    self?.tableView.backgroundView = nil
    }
    self?.tableView.reloadData()
    })
    }
    
//Search bar delegates

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
 //Standard Table View Delegates
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return bookArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BookCell
        let book = bookArray[indexPath.row]
        cell.setBookData(book: book)
        return cell
    }
}



