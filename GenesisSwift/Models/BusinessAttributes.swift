//
//  BusinessAttributes.swift
//  GenesisSwift
//
//  Created by Georgi Yanakiev emerchantpay on 3.04.23.
//  Copyright © 2023 eMerchantPay. All rights reserved.
//

import Foundation

public struct BusinessAttributes {

    public let eventStartDate: Date?
    public let eventEndDate: Date?
    public let eventOrganizerId: String?
    public let eventId: String?
    public let dateOfOrder: Date?
    public let deliveryDate: Date?
    public let nameOfTheSupplier: String?

    public init(eventStartDate: Date? = nil,
                eventEndDate: Date? = nil,
                eventOrganizerId: String? = nil,
                eventId: String? = nil,
                dateOfOrder: Date? = nil,
                deliveryDate: Date? = nil,
                nameOfTheSupplier: String? = nil) {

        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.eventOrganizerId = eventOrganizerId
        self.eventId = eventId
        self.dateOfOrder = dateOfOrder
        self.deliveryDate = deliveryDate
        self.nameOfTheSupplier = nameOfTheSupplier
    }

    subscript(key: String) -> Any? {
        switch key {
        case PropertyKeys.EventStartDateKey: return eventStartDate
        case PropertyKeys.EventEndDateKey: return eventEndDate
        case PropertyKeys.EventOrganizerIdKey: return eventOrganizerId
        case PropertyKeys.EventIdKey: return eventId
        case PropertyKeys.DateOfOrderKey: return dateOfOrder
        case PropertyKeys.DeliveryDateKey: return deliveryDate
        case PropertyKeys.NameOfTheSupplierKey: return nameOfTheSupplier
        default: return nil
        }
    }
}

// MARK: GenesisDescriptionProtocol
extension BusinessAttributes: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }
}

// MARK: GenesisXmlObjectProtocol
extension BusinessAttributes: GenesisXmlObjectProtocol {

    func propertyMap() -> [String: String] {
        [PropertyKeys.EventStartDateKey: "event_start_date",
         PropertyKeys.EventEndDateKey: "event_end_date",
         PropertyKeys.EventOrganizerIdKey: "event_organizer_id",
         PropertyKeys.EventIdKey: "event_id",
         PropertyKeys.DateOfOrderKey: "date_of_order",
         PropertyKeys.DeliveryDateKey: "delivery_date",
         PropertyKeys.NameOfTheSupplierKey: "name_of_the_supplier"]
    }

    func toXmlString() -> String {
        var xmlString = ""
        for (key, value) in propertyMap() {
            guard let varValue = self[key] else { continue }
            xmlString += "<\(value)>" + String(describing: varValue) + "</\(value)>"
        }
        return xmlString
    }
}
