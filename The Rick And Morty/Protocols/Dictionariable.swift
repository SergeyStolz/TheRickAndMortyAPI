//
//  Dictionariable.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

protocol Dictionariable {
    func toDict(isUpperFirtsSymbol: Bool) -> [String: Any]
}

//Mark: - PROTOCOL
protocol OptionalType { init() }

// MARK: - EXTENSION
extension String: OptionalType {}
extension Int: OptionalType {}
extension Double: OptionalType {}
extension Bool: OptionalType {}

//unwrapping values
prefix operator ?*

prefix func ?*<T: OptionalType>( value: T?) -> T {
    guard let validValue = value else { return T() }
    return validValue
}

extension Dictionariable {
    func toDict(isUpperFirtsSymbol: Bool = false) -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            if label != nil, !Optional.isNil(value) {
                if let v = value as? Optional<Any> {
                    let vv = v!
                    return ( isUpperFirtsSymbol ? label!.firstUppercased : label!, vv)
                } else {
                    return nil
                }
            } else { return nil }
        }).compactMap { $0 })
        return dict
    }
}

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
}

extension Optional {
    static func isNil(_ object: Wrapped) -> Bool {
        switch object as Any {
        case Optional<Any>.none:
            return true
        default:
            return false
        }
    }
}
