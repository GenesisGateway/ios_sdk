//
//  PickerDataTests.swift
//  GenesisWebViewTests
//

import XCTest
@testable import iOS_Example
@testable import GenesisSwift

class PickerDataTests: XCTestCase {
    private var sut: PickerData!

    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

// MARK: - Tests

extension PickerDataTests {

    func testPickerData() {
        let item1 = IsoCountryInfo(name: "item1.name", numeric: "item1.numeric", alpha2: "item1.alpha2", alpha3: "item1.alpha3",
                                   calling: "item1.calling", currency: "item1.currency", continent: "item1.continent")

        let item2 = CurrencyInfo(name: .USD, exponent: 1)

        sut = PickerData(title: "fixed.title", value: "fixed.value", items: [item1, item2])

        XCTAssertEqual(sut.title, "fixed.title")
        XCTAssertEqual(sut.value, "fixed.value")

        XCTAssertEqual(sut.items[0].pickerTitle, "\(item1.name) - \(item1.alpha2)")
        XCTAssertEqual(sut.items[0].pickerValue, item1.name)

        XCTAssertEqual(sut.items[1].pickerTitle, item2.name.rawValue)
        XCTAssertEqual(sut.items[1].pickerValue, item2.name.rawValue)
    }

    func testRecurringParamsConversion() {

        XCTAssertNil(InputData.RecurringTypePickerValues.notAvailable.recurringType)
        XCTAssertEqual(InputData.RecurringTypePickerValues.initial.recurringType?.type, RecurringType.TypeValues.initial)
        XCTAssertEqual(InputData.RecurringTypePickerValues.managed.recurringType?.type, RecurringType.TypeValues.managed)
        XCTAssertEqual(InputData.RecurringTypePickerValues.subsequent.recurringType?.type, RecurringType.TypeValues.subsequent)

        XCTAssertNil(InputData.RecurringCategoryPickerValues.notAvailable.recurringCategory)
        XCTAssertEqual(InputData.RecurringCategoryPickerValues.standingOrder.recurringCategory?.category,
                       RecurringCategory.CategoryValues.standingOrder)
        XCTAssertEqual(InputData.RecurringCategoryPickerValues.subscription.recurringCategory?.category,
                       RecurringCategory.CategoryValues.subscription)
    }
}
