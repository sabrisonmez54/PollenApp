////
////  ExcelListModel.swift
////  PollenAppSwiftUI
////
////  Created by Sabri Sönmez on 3/13/21.
////
//
//import Foundation
//
//// MARK: - SheetsListModel
//struct SheetsListModel: Codable {
//    let version, encoding: String
//    let feed: Feed
//}
//
//// MARK: - Feed
//struct Feed: Codable {
//    let xmlns, xmlnsOpenSearch, xmlnsGsx: String
//    let id, updated: ID
//    let category: [Category]
//    let title: Title
//    let link: [Link]
//    let author: [Author]
//    let openSearchTotalResults, openSearchStartIndex: ID
//    let entry: [[String: EntryValue]]
//
//    enum CodingKeys: String, CodingKey {
//        case xmlns
//        case xmlnsOpenSearch = "xmlns$openSearch"
//        case xmlnsGsx = "xmlns$gsx"
//        case id, updated, category, title, link, author
//        case openSearchTotalResults = "openSearch$totalResults"
//        case openSearchStartIndex = "openSearch$startIndex"
//        case entry
//    }
//}
//
//// MARK: - Author
//struct Author: Codable {
//    let name, email: ID
//}
//
//// MARK: - ID
//struct ID: Codable {
//    let t: String
//
//    enum CodingKeys: String, CodingKey {
//        case t = "$t"
//    }
//}
//
//// MARK: - Category
//struct Category: Codable {
//    let scheme, term: String
//}
//
//enum EntryValue: Codable {
//    case entryElementArray([EntryElement])
//    case title(Title)
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if let x = try? container.decode([EntryElement].self) {
//            self = .entryElementArray(x)
//            return
//        }
//        if let x = try? container.decode(Title.self) {
//            self = .title(x)
//            return
//        }
//        throw DecodingError.typeMismatch(EntryValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for EntryValue"))
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .entryElementArray(let x):
//            try container.encode(x)
//        case .title(let x):
//            try container.encode(x)
//        }
//    }
//}
//
//// MARK: - EntryElement
//struct EntryElement: Codable {
//    let scheme, term: String?
//    let rel, type: String?
//    let href: String?
//}
//
//// MARK: - Title
//struct Title: Codable {
//    let t: String
//    let type: TypeEnum?
//
//    enum CodingKeys: String, CodingKey {
//        case t = "$t"
//        case type
//    }
//}
//
//enum TypeEnum: String, Codable {
//    case text = "text"
//}
//
//// MARK: - Link
//struct Link: Codable {
//    let rel: String
//    let type: String
//    let href: String
//}
