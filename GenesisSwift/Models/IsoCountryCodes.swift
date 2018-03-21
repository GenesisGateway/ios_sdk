//
//  IsoCountryCodes.swift
//  GenesisSwift
//

public class IsoCountryCodes {
    
    public class func find(key: String) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter({ $0.alpha2 == key.uppercased() || $0.alpha3 == key.uppercased() || $0.numeric == key })
        return country[0]
    }
    
    public class func search(byName name: String) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter( { $0.name == name } )
        return (!country.isEmpty) ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }
    
    public class func search(byCurrency currency: String) -> [IsoCountryInfo] {
        let country = IsoCountries.allCountries.filter({ $0.currency == currency })
        return country
    }
    
    public class func search(byCallingCode calllingCode: String) -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter({ $0.calling == calllingCode })
        return country[0]
    }
    
    class func search(byNameOrISOCode nameOrISOCode: String)  -> IsoCountryInfo {
        let country = IsoCountries.allCountries.filter( { $0.name == nameOrISOCode || $0.numeric == nameOrISOCode } )
        return (!country.isEmpty) ? country[0] : IsoCountryInfo(name: "", numeric: "", alpha2: "", alpha3: "", calling: "", currency: "", continent: "")
    }
}
