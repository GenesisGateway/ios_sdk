//
//  KlarnaItem.swift
//  GenesisSwift
//

import Foundation

public class KlarnaItem {
    public var itemType: String?//Order line type
    public var quantity: Decimal?//Non-negative. The item quantity.
    public var unitPrice: Decimal?//Minor units. Includes tax, excludes discount. (max value: 100000000)
    public var totalAmount: Decimal?//Includes tax and discount. Must match (quantity unit price) - to- tal discount amount divided by quan- tity. (max value: 100000000)
    public var reference: String?//Article number, SKU or similar.
    public var taxRate: Decimal?//Non-negative. In percent, two implicit decimals. I.e 2500 = 25.00 percent.
    public var totalDiscountAmount: Decimal?//Non-negative minor units. Includes tax.
    public var totalTaxAmount: Decimal?//Must be within 1 of total amount - to- tal amount 10000 / (10000 + tax rate). Negative when type is discount.
    public var imageUrl: String?//URL to an image that can be later embedded in communications between Klarna and the customer. (max 1024 characters)
    public var productUrl: String?//URL to an image that can be later embedded in communications between Klarna and the customer. (max 1024 characters)
    public var quantityUnit: String?//Unit used to describe the quantity, e.g. kg, pcs... If defined has to be 1-8 char- acters
    public var productIdentifiers: [String]?//List with product identifiers
    public var brand: String?//The product’s brand name as generally recognized by consumers. If no brand is available for a product, do not sup- ply any value.
    public var categoryPath: String?//The product’s category path as used in the merchant’s webshop. Include the full and most detailed category and separate the segments with ’ ¿ ’
    public var globalTradeItemNumber: String?//The product’s Global Trade Item Number (GTIN). Common types of GTIN are EAN, ISBN or UPC. Ex- clude dashes and spaces, where possi- ble
    public var manufacturerPartNumber: String?//The product’s Manufacturer Part Number (MPN), which - together with the brand - uniquely identifies a product. Only submit MPNs assigned by a manufacturer and use the most specific MPN possible
    public var merchantData: [String]?//List with merchant data
    public var marketplaceSellerInfo: String?//Information for merchant marketplace
    
    public init() {}
    
    subscript(key: String) -> Any? {
        get {
            switch key {
            case ItemTypeKey: return itemType
            case QuantityKey: return quantity
            case UnitPriceKey: return unitPrice
            case TotalAmountKey: return totalAmount
            case "reference": return reference
            case "taxRate": return taxRate
            case "totalDiscountAmount": return totalDiscountAmount
            case "totalTaxAmount": return totalTaxAmount
            case "imageUrl": return imageUrl
            case "productUrl": return productUrl
            case "quantityUnit": return quantityUnit
            case "productIdentifiers": return productIdentifiers
            case "brand": return brand
            case "categoryPath": return categoryPath
            case "globalTradeItemNumber": return globalTradeItemNumber
            case "manufacturerPartNumber": return manufacturerPartNumber
            case "merchantData": return merchantData
            case "marketplaceSellerInfo": return marketplaceSellerInfo
            default: return nil
            }
        }
    }
}

extension KlarnaItem: ValidateInputDataProtocol {
    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForKlarnaItem()
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)
        
        do {
            try validator.isValidKlarnaItem(item: self)
        } catch {
            throw error
        }
    }
}

extension KlarnaItem: GenesisXmlObjectProtocol {
    func propertyMap() -> ([String : String]) {
        return [
            ItemTypeKey: "item_type",
            QuantityKey: "quantity",
            UnitPriceKey: "unit_price",
            TotalAmountKey: "total_amount",
            "reference": "reference",
            "taxRate": "tax_rate",
            "totalDiscountAmount": "total_discount_amount",
            "totalTaxAmount": "total_tax_amount",
            "imageUrl": "image_url",
            "productUrl": "product_url",
            "quantityUnit": "quantity_unit",
            "productIdentifiers": "product_identifiers",
            "brand": "brand",
            "categoryPath": "category_path",
            "globalTradeItemNumber": "global_trade_item_number",
            "manufacturerPartNumber": "manufacturer_part_number",
            "merchantData": "merchant_data"
        ]
    }
    
    func arraySubkeyForKey(key: String) -> String {
        switch key {
        case "product_identifiers": return "produc_identifier"
        case "merchant_data": return "merchant_data"
        default: return key
        }
    }
    
    func toXmlString() -> String {
        var xmlString = "<item>"

        for (key, value) in self.propertyMap() {
            if (key != "name" && key != "_isDefault") {
                guard let varValue = self[key] else { continue }
                
                if varValue is Array<Any> {
                    xmlString += "<\(value)>"
                    let subkey = self.arraySubkeyForKey(key: value)
                    for itemValue in varValue as! [String] {
                        xmlString += "<\(subkey)>" + itemValue + "</\(subkey)>"
                    }
                    xmlString += "</\(value)>"
                } else if varValue is Decimal {
                    xmlString += "<\(value)>" + String(describing: varValue as! Decimal) + "</\(value)>"
                } else {
                    xmlString += "<\(value)>" + (varValue as! String) + "</\(value)>"
                }
            }
        }
        
        xmlString += "</item>"
        return xmlString
    }
}
