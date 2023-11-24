//
//  IsoCountryCodes.swift
//  GenesisSwift
//

public class IsoCountryCodes {

    public class func find(key: String) -> IsoCountryInfo {
        IsoCountries.allCountries.first { $0.alpha2 == key.uppercased() || $0.alpha3 == key.uppercased() || $0.numeric == key }!
    }

    public class func search(byName name: String) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter { $0.name == name }
        return !country.isEmpty ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }

    public class func search(byCurrency currency: String) -> [IsoCountryInfo] {
        IsoCountries.allCountries.filter { $0.currency == currency }
    }

    public class func search(byCallingCode calllingCode: String) -> IsoCountryInfo {
        IsoCountries.allCountries.first { $0.calling == calllingCode }!
    }

    class func search(byNameOrISOCode nameOrISOCode: String) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.first { $0.name == nameOrISOCode || $0.numeric == nameOrISOCode }
        return country ?? IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }
}
