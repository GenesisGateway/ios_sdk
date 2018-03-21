//
//  GenesisXmlParser.swift
//  GenesisSwift
//

import UIKit

final class GenesisXmlParser: NSObject {
    fileprivate var xmlParser: XMLParser
    fileprivate var elementName: String?
    fileprivate let searchedElement: String
    
    public init(data: Data, searchedElement: String) {
        self.searchedElement = searchedElement
        self.xmlParser = XMLParser(data: data)
        super.init()
        xmlParser.delegate = self
    }
    
    public weak var delegate: GenesisXmlParserDelegate?
    
    public func parse() {
        xmlParser.parse()
    }
}

// MARK: XMLParserDelegate
extension GenesisXmlParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == self.searchedElement {
            self.elementName = nil
            self.delegate?.didEndParsing()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty && self.elementName != nil) {
            self.delegate?.parser(foundCharacters: data, forElementName: self.elementName!)
        }
    }
}

// MARK: GenesisXmlParserDelegate
public protocol GenesisXmlParserDelegate: class {
    func parser(foundCharacters string: String, forElementName elementName: String)
    func didEndParsing()
}
