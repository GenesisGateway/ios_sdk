//
//  KlarnaItem.swift
//  GenesisSwift
//

import Foundation

extension PropertyKeys {
    static let ReferenceKey = "reference"
    static let TaxRateKey = "taxRate"
    static let TotalDiscountAmountKey = "totalDiscountAmount"
    static let TotalTaxAmountKey = "totalTaxAmount"
    static let ImageUrlKey = "imageUrl"
    static let ProductUrlKey = "productUrl"
    static let QuantityUnitKey = "quantityUnit"
    static let ProductIdentifiersKey = "productIdentifiers"
    static let BrandKey = "brand"
    static let CategoryPathKey = "categoryPath"
    static let GlobalTradeItemNumberKey = "globalTradeItemNumber"
    static let ManufacturerPartNumberKey = "manufacturerPartNumber"
    static let MerchantDataKey = "merchantData"
    static let MarketplaceSellerInfoKey = "marketplaceSellerInfo"
}

public class KlarnaItem {
    public var itemType: String? // Order line type
    public var quantity: Decimal? // Non-negative. The item quantity.
    public var unitPrice: Decimal? // Minor units. Includes tax, excludes discount. (max value: 100000000)

    // Includes tax and discount. Must match (quantity unit price) - to- tal discount amount divided by quan- tity. (max value: 100000000)
    public var totalAmount: Decimal?

    public var reference: String? // Article number, SKU or similar.
    public var taxRate: Decimal? // Non-negative. In percent, two implicit decimals. I.e 2500 = 25.00 percent.
    public var totalDiscountAmount: Decimal? // Non-negative minor units. Includes tax.

    // Must be within 1 of total amount - to- tal amount 10000 / (10000 + tax rate). Negative when type is discount.
    public var totalTaxAmount: Decimal?

    // URL to an image that can be later embedded in communications between Klarna and the customer. (max 1024 characters)
    public var imageUrl: String?

    // URL to an image that can be later embedded in communications between Klarna and the customer. (max 1024 characters)
    public var productUrl: String?

    // Unit used to describe the quantity, e.g. kg, pcs... If defined has to be 1-8 char- acters
    public var quantityUnit: String?

    // List with product identifiers
    public var productIdentifiers: [String]?

    // The product’s brand name as generally recognized by consumers. If no brand is available for a product, do not supply any value.
    public var brand: String?

    // The product’s category path as used in the merchant’s webshop.
    // Include the full and most detailed category and separate the segments with ’ > ’
    public var categoryPath: String?

    // The product’s Global Trade Item Number (GTIN). Common types of GTIN are EAN, ISBN or UPC. Ex- clude dashes and spaces, where possible
    public var globalTradeItemNumber: String?

    // The product’s Manufacturer Part Number (MPN), which - together with the brand - uniquely identifies a product.
    // Only submit MPNs assigned by a manufacturer and use the most specific MPN possible
    public var manufacturerPartNumber: String?

    public var merchantData: [String]? // List with merchant data
    public var marketplaceSellerInfo: String? // Information for merchant marketplace

    public init() {}

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.ItemTypeKey: return itemType
        case PropertyKeys.QuantityKey: return quantity
        case PropertyKeys.UnitPriceKey: return unitPrice
        case PropertyKeys.TotalAmountKey: return totalAmount
        case PropertyKeys.ReferenceKey: return reference
        case PropertyKeys.TaxRateKey: return taxRate
        case PropertyKeys.TotalDiscountAmountKey: return totalDiscountAmount
        case PropertyKeys.TotalTaxAmountKey: return totalTaxAmount
        case PropertyKeys.ImageUrlKey: return imageUrl
        case PropertyKeys.ProductUrlKey: return productUrl
        case PropertyKeys.QuantityUnitKey: return quantityUnit
        case PropertyKeys.ProductIdentifiersKey: return productIdentifiers
        case PropertyKeys.BrandKey: return brand
        case PropertyKeys.CategoryPathKey: return categoryPath
        case PropertyKeys.GlobalTradeItemNumberKey: return globalTradeItemNumber
        case PropertyKeys.ManufacturerPartNumberKey: return manufacturerPartNumber
        case PropertyKeys.MerchantDataKey: return merchantData
        case PropertyKeys.MarketplaceSellerInfoKey: return marketplaceSellerInfo
        default: return nil
        }
    }
}

extension KlarnaItem: ValidateInputDataProtocol {
    public func isValidData() throws {
        let requiredParameters = RequiredParameters.requiredParametersForKlarnaItem()
        let validator = RequiredParametersValidator(withRequiredParameters: requiredParameters)
        try validator.isValidKlarnaItem(item: self)
    }
}

extension KlarnaItem: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        [PropertyKeys.ItemTypeKey: "item_type",
         PropertyKeys.QuantityKey: "quantity",
         PropertyKeys.UnitPriceKey: "unit_price",
         PropertyKeys.TotalAmountKey: "total_amount",
         PropertyKeys.ReferenceKey: "reference",
         PropertyKeys.TaxRateKey: "tax_rate",
         PropertyKeys.TotalDiscountAmountKey: "total_discount_amount",
         PropertyKeys.TotalTaxAmountKey: "total_tax_amount",
         PropertyKeys.ImageUrlKey: "image_url",
         PropertyKeys.ProductUrlKey: "product_url",
         PropertyKeys.QuantityUnitKey: "quantity_unit",
         PropertyKeys.ProductIdentifiersKey: "product_identifiers",
         PropertyKeys.BrandKey: "brand",
         PropertyKeys.CategoryPathKey: "category_path",
         PropertyKeys.GlobalTradeItemNumberKey: "global_trade_item_number",
         PropertyKeys.ManufacturerPartNumberKey: "manufacturer_part_number",
         PropertyKeys.MerchantDataKey: "merchant_data",
         PropertyKeys.MarketplaceSellerInfoKey: "marketplace_seller_info"]
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

        for (key, value) in propertyMap() {
            guard key != PropertyKeys.NameKey && key != PropertyKeys.IsDefaultKey else { continue }
            guard let varValue = self[key] else { continue }

            if let varValue = varValue as? [String] {
                xmlString += "<\(value)>"
                let subkey = arraySubkeyForKey(key: value)
                for itemValue in varValue {
                    xmlString += "<\(subkey)>" + itemValue + "</\(subkey)>"
                }
                xmlString += "</\(value)>"
            } else if let varValue = varValue as? Decimal {
                xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
            } else if let varValue = varValue as? String {
                xmlString += "<\(value)>" + varValue + "</\(value)>"
            }
        }

        xmlString += "</item>"
        return xmlString
    }
}
