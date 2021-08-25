//
//  DateFormatter+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import Foundation

extension DateFormatter {
    /**
     format: dd/MM/yyyy
     e.g: 01/01/2020
     */
    static var format1: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
    
    /**
     format: d MMM yyyy
     e.g: 1 Jan 2020
     */
    static var format2: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter
    }
    
    /**
     format: d MMM yyyy hh:mm a
     e.g: 1 Jan 2020 10:00 AM
     */
    static var format3: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy hh:mm a"
        return dateFormatter
    }
    
    /**
     format: hh:mm a
     e.g: 10:00 AM
     */
    static var format4: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }
    
    /**
     format: d MMM
     e.g: 1 Jan
     */
    static var format5: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter
    }
    
    /**
     format: d MMM
     e.g: 10 Jun 2020, 10:27 PM
     */
    static var format6: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy, hh:mm a"
        return dateFormatter
    }
    
    /**
     format: yyyy-MM-dd'T'HH:mm:ss.SSSSSS
     e.g: 2020-12-21T14:12:14.6205427
     */
    static var serverFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return dateFormatter
    }
    
    /**
     format: yyyy-MM-dd'T'HH:mm:ss
     e.g: 2019-07-08T21:41:09
     */
    static var serverShortFormat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter
    }
}
