//
//  GenesisXmlParser.swift
//  GenesisSwift
//

import UIKit

final class GenesisXmlParser: NSObject {
    fileprivate var xmlParser: XMLParser
    fileprivate var elementName: String?
    fileprivate let searchedElement: String

    init(data: Data, searchedElement: String) {
        self.searchedElement = searchedElement
        self.xmlParser = XMLParser(data: data)
        super.init()
        xmlParser.delegate = self
    }

    weak var delegate: GenesisXmlParserDelegate?

    func parse() {
        xmlParser.parse()
    }
}

// MARK: - XMLParserDelegate
extension GenesisXmlParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == searchedElement {
            self.elementName = nil
            delegate?.didEndParsing()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !data.isEmpty && elementName != nil {
            delegate?.parser(foundCharacters: data, forElementName: elementName!)
        }
    }
}

// MARK: - GenesisXmlParserDelegates

protocol GenesisXmlParserDelegate: AnyObject {
    func parser(foundCharacters string: String, forElementName elementName: String)
    func didEndParsing()
}
