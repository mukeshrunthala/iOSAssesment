//
//  Book.swift
//  iOSAssesment
//
//  Created by Mukesh on 28/02/2022.

//all of the decodable structs can be found here
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

