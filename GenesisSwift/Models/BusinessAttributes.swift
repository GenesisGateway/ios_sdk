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
        case EventStartDateKey: return eventStartDate
        case EventEndDateKey: return eventEndDate
        case EventOrganizerIdKey: return eventOrganizerId
        case EventIdKey: return eventId
        case DateOfOrderKey: return dateOfOrder
        case DeliveryDateKey: return deliveryDate
        case NameOfTheSupplierKey: return nameOfTheSupplier
        default: return nil
        }
    }
}

//MARK: GenesisDescriptionProtocol
extension BusinessAttributes: GenesisDescriptionProtocol {
    func description() -> String {
        toXmlString()
    }

}

// MARK: GenesisXmlObjectProtocol
extension BusinessAttributes: GenesisXmlObjectProtocol {
    func propertyMap() -> [String : String] {
        [EventStartDateKey: "event_start_date",
           EventEndDateKey: "event_end_date",
       EventOrganizerIdKey: "event_organizer_id",
                EventIdKey: "event_id",
            DateOfOrderKey: "date_of_order",
           DeliveryDateKey: "delivery_date",
      NameOfTheSupplierKey: "name_of_the_supplier"]
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
