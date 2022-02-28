//
//  LibraryPresenter.swift
//  Library_API_Case_Study
//
//  Created by Anthony Rubin on 4/14/19.
//  Copyright © 2019 Anthony Rubin. All rights reserved.
//

import UIKit
import CoreData
class BookSearch: NSObject {
    
    let baseURL = "https://openlibrary.org/search.json?title="
    var timer: Timer?
    var searchCompletion: ((BookObject) -> Void)?
    
    //**Imports JSON data from given URL
    func importJson(url: String, completion: @escaping (BookObject) -> Void){
        let ValidUrl = URL(string: url)
        guard let jsonUrl = ValidUrl else {
            return
        }
        URLSession.shared.dataTask(with: jsonUrl, completionHandler: { (data, response, error) in
            guard let data = data else {
                return
            }
            do{
                let object = try JSONDecoder().decode(BookObject.self, from: data)
                DispatchQueue.main.async {
                    completion(object)
                }
            }catch{
                print(error)
            }
        }).resume()
    }

    func searchBooks(keyword: String, emptyCompletion: () -> Void, searchCompletion: @escaping (BookObject) -> Void) {
        timer?.invalidate()
        self.searchCompletion = searchCompletion
        if keyword.isEmpty {
            emptyCompletion()
            return
        }
        let url = baseURL + "\(keyword)" + "&limit=10"
        startSearching(url: url)
    }
    
    //**This function will update the url and call import json function
    func startSearching(url : String) {
        let newUrl = url.replacingOccurrences(of: " ", with: "+")
        print("url is " + newUrl)
        guard let completion = searchCompletion else { return }
        importJson(url: newUrl, completion: completion)
    }
}


    

