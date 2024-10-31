//
//  DynamicDescriptorParams.swift
//  GenesisSwift
//

import Foundation

public struct DynamicDescriptorParams {
    public let merchantName: String?
    public let merchantCity: String?
    public let merchantCountry: String?
    public let merchantState: String?
    public let merchantZipCode: String?
    public let merchantAddress: String?
    public let merchantUrl: String?
    public let merchantPhone: String?
    public let merchantServiceCity: String?
    public let merchantServiceCountry: String?
    public let merchantServiceState: String?
    public let merchantServiceZipCode: String?
    public let merchantServicePhone: String?
    public let subMerchantId: String?
    public let merchantGeoCoordinates: String?
    public let merchantServiceGeoCoordinates: String?

    public init(merchantName: String? = nil,
                merchantCity: String? = nil,
                merchantCountry: String? = nil,
                merchantState: String? = nil,
                merchantZipCode: String? = nil,
                merchantAddress: String? = nil,
                merchantUrl: String? = nil,
                merchantPhone: String? = nil,
                merchantServiceCity: String? = nil,
                merchantServiceCountry: String? = nil,
                merchantServiceState: String? = nil,
                merchantServiceZipCode: String? = nil,
                merchantServicePhone: String? = nil,
                subMerchantId: String? = nil,
                merchantGeoCoordinates: String? = nil,
                merchantServiceGeoCoordinates: String? = nil) {
        self.merchantName = merchantName
        self.merchantCity = merchantCity
        self.merchantCountry = merchantCountry
        self.merchantState = merchantState
        self.merchantZipCode = merchantZipCode
        self.merchantAddress = merchantAddress
        self.merchantUrl = merchantUrl
        self.merchantPhone = merchantPhone
        self.merchantServiceCity = merchantServiceCity
        self.merchantServiceCountry = merchantServiceCountry
        self.merchantServiceState = merchantServiceState
        self.merchantServiceZipCode = merchantServiceZipCode
        self.merchantServicePhone = merchantServicePhone
        self.subMerchantId = subMerchantId
        self.merchantGeoCoordinates = merchantGeoCoordinates
        self.merchantServiceGeoCoordinates = merchantServiceGeoCoordinates
    }

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.MerchantNameKey: return merchantName
        case PropertyKeys.MerchantCityKey: return merchantCity
        case PropertyKeys.MerchantCountryKey: return merchantCountry
        case PropertyKeys.MerchantStateKey: return merchantState
        case PropertyKeys.MerchantZipCodeKey: return merchantZipCode
        case PropertyKeys.MerchantAddressKey: return merchantAddress
        case PropertyKeys.MerchantUrlKey: return merchantUrl
        case PropertyKeys.MerchantPhoneKey: return merchantPhone
        case PropertyKeys.MerchantServiceCityKey: return merchantServiceCity
        case PropertyKeys.MerchantServiceCountryKey: return merchantServiceCountry
        case PropertyKeys.MerchantServiceStateKey: return merchantServiceState
        case PropertyKeys.MerchantServiceZipCodeKey: return merchantServiceZipCode
        case PropertyKeys.MerchantServicePhoneKey: return merchantServicePhone
        case PropertyKeys.SubMerchantIdKey: return subMerchantId
        case PropertyKeys.MerchantGeoCoordinatesKeys: return merchantGeoCoordinates
        case PropertyKeys.MerchantServiceGeoCoordinatesKey: return merchantServiceGeoCoordinates
        default: return nil
        }
    }
}

// MARK: - GenesisDescriptionProtocol
extension DynamicDescriptorParams: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }
}

// MARK: - GenesisXmlObjectProtocol
extension DynamicDescriptorParams: GenesisXmlObjectProtocol {
    func propertyMap() -> [String: String] {
        [PropertyKeys.MerchantNameKey: "merchant_name",
         PropertyKeys.MerchantCityKey: "merchant_city",
         PropertyKeys.MerchantCountryKey: "merchant_country",
         PropertyKeys.MerchantStateKey: "merchant_state",
         PropertyKeys.MerchantZipCodeKey: "merchant_zip_code",
         PropertyKeys.MerchantAddressKey: "merchant_address",
         PropertyKeys.MerchantUrlKey: "merchant_url",
         PropertyKeys.MerchantPhoneKey: "merchant_phone",
         PropertyKeys.MerchantServiceCityKey: "merchant_service_city",
         PropertyKeys.MerchantServiceCountryKey: "merchant_service_country",
         PropertyKeys.MerchantServiceStateKey: "merchant_service_state",
         PropertyKeys.MerchantServiceZipCodeKey: "merchant_service_zip_code",
         PropertyKeys.MerchantServicePhoneKey: "merchant_service_phone",
         PropertyKeys.SubMerchantIdKey: "sub_merchant_id",
         PropertyKeys.MerchantGeoCoordinatesKeys: "merchant_geo_coordinates",
         PropertyKeys.MerchantServiceGeoCoordinatesKey: "merchant_service_geo_coordinates"]
    }

    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in propertyMap() {
            if let varValue = self[key] {
                xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
            }
        }
        return xmlString
    }
}
