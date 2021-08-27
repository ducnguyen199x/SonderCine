//
//  String+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension String {
    enum RegexType: String {
        case none = ""
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        case mobile = "^[0-9]*$"
        case floatNumber = "([0-9]*[.])?[0-9]+"
    }
    
    enum FileType: String {
        case image
        case video
        
        var exts: [String] {
            switch self {
            case .image:
                return ["PNG", "JPEG", "JPG"]
            case .video:
                return ["MOV", "MP4", "M4V"]
            }
        }
    }
    
    func systemImage() -> UIImage? {
        return UIImage(systemName: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont = .systemFont(ofSize: 17.0, weight: .semibold)) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .center
        
        let attributes = [
            kCTFontAttributeName: font, kCTParagraphStyleAttributeName: paragraphStyle
        ]
        
        let bodyBounds = (self as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: attributes as [NSAttributedString.Key: Any],
                                                         context: nil)
        
        return bodyBounds.height
    }
    
    func stripOutHTML() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func getAttributedStrings() -> [AttributedTag: [String]] {
        var attributedStrings: [AttributedTag: [String]] = [:]
        AttributedTag.allCases.forEach { tag in
            guard let regex = try? NSRegularExpression(pattern: tag.rawValue, options: .caseInsensitive) else { return }
            let rangeOfTags = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count)).map { $0.range }
            let tagLength = tag.rawValue.count
            var resultStrings: [String] = []
            for index in stride(from: 0, to: rangeOfTags.count, by: 2) {
                // Ranges of 2 begin tag and end tag
                let endTagRange: NSRange? = (index < (rangeOfTags.count - 1) ? rangeOfTags[(index + 1)] : nil)
                if endTagRange == nil { break }
                let beginTagRange = rangeOfTags[index]
                let beginLocation = beginTagRange.location + tagLength
                let endLocation = endTagRange!.location
                let string = (self as NSString).substring(with: NSRange(location: beginLocation, length: endLocation - beginLocation))
                resultStrings.append(string.stripOutHTML())
            }
            guard !resultStrings.isEmpty else { return }
            attributedStrings[tag] = resultStrings
        }
        return attributedStrings
    }
    
    func getAttributedRanges() -> [AttributedTag: [NSRange]] {
        var attributedRanges: [AttributedTag: [NSRange]] = [:]
        AttributedTag.allCases.forEach { tag in
            guard let regex = try? NSRegularExpression(pattern: tag.rawValue, options: .caseInsensitive) else { return }
            let rangeOfTags = regex.matches(in: self, options: [], range: NSRange(location: 0, length: count)).map { $0.range }
            var resultRanges: [NSRange] = []
            if !tag.isSpecialCharacter {
                for index in stride(from: 0, to: rangeOfTags.count, by: 2)
                where index < (rangeOfTags.count - 1) {
                    let beginTagRange = rangeOfTags[index]
                    let endTagRange = rangeOfTags[(index + 1)]
                    let length = endTagRange.upperBound - beginTagRange.lowerBound
                    let range = NSRange(location: beginTagRange.lowerBound, length: length)
                    resultRanges.append(range)
                }
                attributedRanges[tag] = resultRanges
            } else {
                attributedRanges[tag] = rangeOfTags
            }
        }
        
        return attributedRanges
    }
    
    func isFileType(_ type: FileType) -> Bool {
        let components = self.split(separator: ".")
        guard components.count >= 2, let ext = components.last else { return false }
        return type.exts.contains(String(ext).uppercased())
    }
}

// Regex
extension String {
    var fullRange: NSRange {
        return NSRange(location: 0, length: count)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = RegexType.email.rawValue
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidMobileNumber: Bool {
        let emailRegEx = RegexType.mobile.rawValue
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidFloatNumber: Bool {
        let regEx = RegexType.floatNumber.rawValue
        let test = NSPredicate(format: "SELF MATCHES %@", regEx)
        return test.evaluate(with: self)
    }
    
    func removeNonDigit() -> String {
        self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func trim() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func split(_ length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}

// Html
extension String {
    func htmlToAttributedString(fontFamily: String? = nil, fontSize: CGFloat? = nil) -> NSAttributedString? {
        var modifiedFontString = self
        if let fontFamily = fontFamily, let fontSize = fontSize {
            modifiedFontString = "<span style=\"font-family: \(fontFamily)"
                + "; font-size: \(fontSize)\">"
                + self
                + "</span>"
        } else if let fontSize = fontSize {
            modifiedFontString = "<span style=\"font-size: \(fontSize)\">"
                + self
                + "</span>"
        } else if let fontFamily = fontFamily {
            modifiedFontString = "<span style=\"font-family: \(fontFamily)\">"
                + self
                + "</span>"
        }
        
        guard let data = modifiedFontString.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options:
                                            [.documentType: NSAttributedString.DocumentType.html,
                                             .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    func htmlToString(fontFamily: String?, fontSize: CGFloat?) -> String {
        return htmlToAttributedString(fontFamily: fontFamily, fontSize: fontSize)?.string ?? ""
    }
    
    func adding(_ attributedTag: AttributedTag) -> String {
        if attributedTag.isSpecialCharacter {
            return attributedTag.rawValue + self
        } else {
            return attributedTag.rawValue + self + attributedTag.rawValue
        }
    }
}

// URL
extension String {
    func encodeUrlQueryAllowedCharacter() -> String {
        if URL(string: self) != nil {
            return self
        }
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    func generateQRCode() -> UIImage? {
        let data = self.data(using: .ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

extension String {
    subscript(range: NSRange) -> String {
        let lowerBoundIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let upperBoundIndex = index(lowerBoundIndex, offsetBy: range.length)
        let substring = self[lowerBoundIndex..<upperBoundIndex]
        return String(substring)
    }
}
