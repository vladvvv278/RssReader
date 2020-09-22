//
//  XmlParserManager.swift
//  RssParser
//
//  Created by vladislav on 18.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public class XmlParserManager: NSObject, RssParserManager, XMLParserDelegate {

    fileprivate var parser: XMLParser?
    
    fileprivate var currentElement = ""
    fileprivate var foundCharacters = ""
    fileprivate var currentData = [String:String]()
    fileprivate var parsedData = [[String:String]]()
    
    fileprivate let allowedKeys = ["title", "link", "description", "content", "pubDate", "author", "dc:creator", "content:encoded"]
    
    public func parse<T>(data: Data, completion: @escaping (Result<[T], ParserError>) -> Void) where T : RssParsableModel {
        parser = XMLParser.init(data: data)
        parser?.delegate = self
        if parser?.parse() == true {
            var result = [T]()
            for item in parsedData {
                do {
                    let object = try T.init(data: item)
                    result.append(object)
                } catch {
                    continue
                }
            }
            completion(Result.success(result))
        }
    }
    
    public func parserDidStartDocument(_ parser: XMLParser) {
        parsedData.removeAll()
        currentData.removeAll()
    }
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" || currentElement == "entry" {
            parsedData.append(currentData)
            currentData.removeAll()
        }
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        if allowedKeys.contains(currentElement) {
            foundCharacters += string
            foundCharacters = foundCharacters.deleteHTMLTags(tags: ["a", "p", "div", "img"])
        }
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if foundCharacters.isEmpty {
            return
        }
        foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
        currentData[currentElement] = foundCharacters
        foundCharacters.removeAll()
    }
    
    public func parserDidEndDocument(_ parser: XMLParser) {
        parsedData.append(currentData)
        currentData.removeAll()
    }
    
}
