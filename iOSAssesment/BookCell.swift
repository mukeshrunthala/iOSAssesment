//
//  TableViewCell.swift
//  Library_API_Case_Study
//
//  Created by Anthony Rubin on 4/12/19.
//  Copyright © 2019 Anthony Rubin. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    let imgBaseURL = "https://covers.openlibrary.org/b/id/"
    
    func setBookData(book: Book){
        if(title != nil){
            self.title.text = book.title_suggest
        }
        if let author = book.author_name {
            if(author.count>0){
                self.author.text = author[0]
                for (i, c) in (author.enumerated()){
                    if(i>0){
                        self.author.text = self.author.text! + ", " + c
                    }
                }
            }
        }
        if(book.first_publish_year != nil){
            self.publishDate.text = "\(book.first_publish_year!)"
        }
        if(book.cover_i != nil && book.cover_i! > 0){
            getImage(cover_i: book.cover_i!)
        }else{
            imgNotFound()
        }

    }
    
    func imgNotFound(){
        self.bookImage.image = UIImage(named: "book")
    }
    
    func getImage(cover_i: Int){
        let url = imgBaseURL + "\(cover_i)" + "-M.jpg"
        //check that url is valid
            if let imageURL = URL(string: url){
                //perform work in background thread
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: imageURL)
                    if let data = data {
                        let image = UIImage(data: data)
                //switch back to main thread and update UI
                        DispatchQueue.main.async {
                            self.bookImage.image = image
                        }
                    }
                }
            }
    }
}



