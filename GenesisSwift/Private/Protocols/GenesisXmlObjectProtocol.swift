//
//  GenesisXmlObjectProtocol.swift
//  GenesisSwift
//

// MARK: - GenesisXmlObjectProtocol

protocol GenesisXmlObjectProtocol {
    func propertyMap() -> [String: String]
    func toXmlString() -> String
}

// MARK: - GenesisDescriptionProtocol

protocol GenesisDescriptionProtocol {
    func description() -> String
}

// MARK: - XMLDescribable

protocol XMLConvertable {
    func toXML(name: String, value: String?) -> String
}

extension XMLConvertable {

    func toXML(name: String, value: String?) -> String {
        guard let value = value, !value.isEmpty else { return "" }
        let xml = "<\(name)>" + value + "</\(name)>"
        return xml
    }
}

