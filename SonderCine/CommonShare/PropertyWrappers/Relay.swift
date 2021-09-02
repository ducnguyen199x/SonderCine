//
//  Relay.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import Foundation
import RxRelay

@propertyWrapper
class Relay<Value> {
    var relay: BehaviorRelay<Value>

    init(wrappedValue: Value) {
        relay = BehaviorRelay<Value>(value: wrappedValue)
    }

    var wrappedValue: Value {
        get {
            return relay.value
        }

        set {
            relay.accept(newValue)
        }
    }

    var projectedValue: BehaviorRelay<Value> {
        return relay
    }
}
