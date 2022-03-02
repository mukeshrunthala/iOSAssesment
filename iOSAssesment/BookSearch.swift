//
//  LibraryPresenter.swift
//  iOSAssesment
//
//  Created by Mukesh on 28/02/2022.
//

import UIKit
import CoreData
class BookSearch: NSObject {
    
    let baseURL = "https://openlibrary.org/search.json?title="
    var timer: Timer?
    var searchCompletion: (([Book]) -> Void)?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    //This function will fetch data from OpenLibrary
    func importJson(url: String, completion: @escaping ([Book]) -> Void){
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
                for book in object.docs
                {
                    self.addToLocalDB(bookObj: book)
                }
                DispatchQueue.main.async {
                    print("api result")
                    completion(object.docs)
                }
            }catch{
                print(error)
            }
        }).resume()
    }

    func searchBooks(keyword: String, emptyCompletion: () -> Void, searchCompletion: @escaping ([Book]) -> Void) {
        timer?.invalidate()
        self.searchCompletion = searchCompletion
        if keyword.isEmpty {
            emptyCompletion()
            return
        }
        if let completion = self.searchCompletion {
        searchLocalDatabase(title: keyword, completion: completion)
        }
    }
    
    //**This function will update the url and call import json function
    func startSearching(url : String) {
        let newUrl = url.replacingOccurrences(of: " ", with: "+")
        print("url is " + newUrl)
        guard let completion = searchCompletion else { return }
        importJson(url: newUrl, completion: completion)
    }
}
    

// CoreData Functions

extension BookSearch
{
    //This Function will Search keyword in locall DataBase
    func searchLocalDatabase(title: String, completion: @escaping ([Book]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookTable")
        fetchRequest.predicate = NSPredicate(format:  "title_suggest CONTAINS[cd] %@", title)
        fetchRequest.fetchLimit = 10

        do {
            if let managedContext = appDelegate?.persistentContainer.viewContext  {
                let bookLocalDB = try managedContext.fetch(fetchRequest) as! [BookTable]
                if bookLocalDB.count > 0
                {
                    var arrBook = [Book]()
                    for obj in bookLocalDB
                    {
                        let tempBook = Book(book: obj)
                        arrBook.append(tempBook)
                    }
                    DispatchQueue.main.async {
                        print("local result")
                        completion(arrBook)
                    }
                }
                else
                {
                    let url = baseURL + "\(title)" + "&limit=10"
                    startSearching(url: url)
                }
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }
    }
    
    // This function wil check record is already exist or not
    func someEntityExists(id: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookTable")
        fetchRequest.predicate = NSPredicate(format: "key = %@", id)
        fetchRequest.includesSubentities = false

        var entitiesCount = 0

        do {
            if let managedContext = appDelegate?.persistentContainer.viewContext  {
                entitiesCount = try managedContext.count(for: fetchRequest)
                
            }
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return entitiesCount > 0
    }
    
    // This function will insert data in local Database
    func addToLocalDB(bookObj : Book) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
               return
           }
           let book = BookTable(context: managedContext)
       
       let check = self.someEntityExists(id: bookObj.key ?? "")
       
       if check == true
       {
           return
       }
       if(bookObj.key != nil && bookObj.key!.count > 0){
           book.key = bookObj.key
       }
        if(bookObj.author_name.count > 0){
            book.author = bookObj.author_name[0]
       }

        if(bookObj.first_publish_year != nil){
           book.publishDate = Int32(bookObj.first_publish_year!)
       }
       if(bookObj.title_suggest != nil){
           book.title_suggest = bookObj.title_suggest
       }

       if(bookObj.cover_i != nil && bookObj.cover_i! > 0){
           book.cover_i = Int32(bookObj.cover_i!)
       }
           do{
               appDelegate?.saveContext()
               try managedContext.save()
           }catch{
               print("failed to save", error.localizedDescription)
           }
   
   }
}
