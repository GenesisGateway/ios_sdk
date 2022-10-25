//
//  MerchantRiskParams.swift
//  GenesisSwift
//
//  Created by Ivaylo Hadzhiev on 14.10.22.
//  Copyright © 2022 eMerchantPay. All rights reserved.
//

import Foundation

public extension ThreeDSV2Params {

    struct MerchantRiskParams {

        public enum ShippingIndicatorValues: String, CaseIterable {
            case sameAsBilling = "same_as_billing"
            case storedAddress = "stored_address"
            case verifiedAddress = "verified_address"
            case pickUp = "pick_up"
            case digitalGoods = "digital_goods"
            case travel
            case eventTickets = "event_tickets"
            case other
        }

        public enum DeliveryTimeframeValues: String, CaseIterable {
            case electronic
            case sameDay = "same_day"
            case overNight = "over_night"
            case anotherDay = "another_day"
        }

        public enum ReorderItemsIndicatorValues: String, CaseIterable {
            case firstTime = "first_time"
            case reordered
        }

        public enum PreOrderPurchaseIndicatorValues: String, CaseIterable {
            case merchandiseAvailable = "merchandise_available"
            case futureAvailability = "future_availability"
        }

        public var shippingIndicator: ShippingIndicatorValues?
        public var deliveryTimeframe: DeliveryTimeframeValues?
        public var reorderItemsIndicator: ReorderItemsIndicatorValues?
        public var preOrderPurchaseIndicator: PreOrderPurchaseIndicatorValues?
        public var preOrderDate: Date?
        public var giftCard: Bool?
        public var giftCardCount: Int?

        public init(shippingIndicator: ShippingIndicatorValues? = nil,
                    deliveryTimeframe: DeliveryTimeframeValues? = nil,
                    reorderItemsIndicator: ReorderItemsIndicatorValues? = nil,
                    preOrderPurchaseIndicator: PreOrderPurchaseIndicatorValues? = nil,
                    preOrderDate: Date? = nil,
                    giftCard: Bool? = nil,
                    giftCardCount: Int? = nil) {
            self.shippingIndicator = shippingIndicator
            self.deliveryTimeframe = deliveryTimeframe
            self.reorderItemsIndicator = reorderItemsIndicator
            self.preOrderPurchaseIndicator = preOrderPurchaseIndicator
            self.preOrderDate = preOrderDate
            self.giftCard = giftCard
            self.giftCardCount = giftCardCount
        }
    }
}

// MARK: - GenesisDescriptionProtocol

extension ThreeDSV2Params.MerchantRiskParams: GenesisDescriptionProtocol, XMLConvertable {

    func description() -> String {
        var xmlString = ""

        xmlString += toXML(name: "shipping_indicator", value: shippingIndicator?.rawValue)
        xmlString += toXML(name: "delivery_timeframe", value: deliveryTimeframe?.rawValue)
        xmlString += toXML(name: "reorder_items_indicator", value: reorderItemsIndicator?.rawValue)
        xmlString += toXML(name: "pre_order_purchase_indicator", value: preOrderPurchaseIndicator?.rawValue)
        xmlString += toXML(name: "pre_order_date", value: preOrderDate?.iso8601Date)
        if let giftCard = giftCard {
            xmlString += toXML(name: "gift_card", value: giftCard ? "true" : "false")
        }
        if let giftCardCount = giftCardCount {
            xmlString += toXML(name: "gift_card_count", value: String(describing: giftCardCount))
        }

        return xmlString
    }
}
