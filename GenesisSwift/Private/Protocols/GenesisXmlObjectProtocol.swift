//
//  GenesisXmlObjectProtocol.swift
//  GenesisSwift
//

protocol GenesisXmlObjectProtocol {
    func propertyMap() -> ([String : String])
    func toXmlString() -> String
}

protocol GenesisDescriptionProtocol {
    func description() -> String
}
