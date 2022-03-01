//
//  Book.swift
//  Library_API_Case_Study
//
//  Created by Anthony Rubin on 4/12/19.
//  Copyright © 2019 Anthony Rubin. All rights reserved.
//
//all of the decodable structs can be found here
//these structs are the bones of the JSON Parsing
import Foundation

struct Book: Decodable{
    var title_suggest: String?
    var author_name: [String?]
    var first_publish_year: Int?
    var cover_i: Int?
    var key: String?
    
    init(book : BookTable) {
        title_suggest = book.title_suggest
        author_name = [book.author]
        first_publish_year = Int(book.publishDate)
        cover_i = Int(book.cover_i)
        key = book.key
        }
}
struct BookObject: Decodable {
    let start: Int?
    let num_found: Int?
    let docs: [Book]
}

