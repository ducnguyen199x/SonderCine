//
//  NSMutableAttributedString+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

enum AttributedTag: String, CaseIterable {
    case bold = "<b>"
    case semibold = "<sb>"
    case italic = "<i>"
    case boldItalic = "<sbi>"
    case underline = "<u>"
    case link = "<a>"
    case highlight = "<hl>"
    case indent = "<indent>"

    var isSpecialCharacter: Bool {
        switch self {
        case .indent: return true
        default: return false
        }
    }
    
    var isFontAttribute: Bool {
        switch self {
        case .bold, .semibold, .italic, .boldItalic: return true
        default: return false
        }
    }
    
    var isColorAttribute: Bool {
        self == .highlight
    }
    
    var replacingString: String {
        self == .indent ? "•  " : ""
    }
    
    var foregroundColor: UIColor {
        switch self {
        case .highlight:
            return .orange
        default:
            return .black
        }
    }
    
    func font(_ size: CGFloat = 17) -> UIFont {
        switch self {
        case .bold: return .boldSystemFont(ofSize: size)
        case .semibold: return .boldSystemFont(ofSize: size)
        case .boldItalic: return .italicSystemFont(ofSize: size)
        case .italic: return .italicSystemFont(ofSize: size)
        case .indent: return .boldSystemFont(ofSize: 24)
        default: return .systemFont(ofSize: size)
        }
    }
}

// MARK: - NSAttributedString Extension
extension NSAttributedString {
    @objc public func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
         return NSMutableAttributedString(attributedString: self).setLineSpacing(spacing)
    }
    
    func toHtml() -> String {
        let attrs = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        guard let data = try? data(from: NSRange(location: 0,
                                                 length: length),
                                   documentAttributes: attrs) else { return string }
        return String(data: data, encoding: .utf8) ?? string
    }
}

// MARK: - NSMutableAttributedString Extension
extension NSMutableAttributedString {
    @discardableResult
    public override func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: string.count))
        return self
    }

    open func replaceAttribute(_ name: Key, value: Any, range: NSRange) {
        removeAttribute(name, range: range)
        addAttribute(name, value: value, range: range)
    }
}

extension NSMutableAttributedString {
    @discardableResult
    open func underline(_ style: NSUnderlineStyle = .single, for range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(.underlineStyle, value: style.rawValue, range: range ?? string.fullRange)
        return self
    }
    
    @discardableResult
    open func foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(.foregroundColor, value: color, range: range ?? string.fullRange)
        return self
    }

    @discardableResult
    open func backgroundColor(_ color: UIColor, for range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(.backgroundColor, value: color, range: range ?? string.fullRange)
        return self
    }

    @discardableResult
    open func font(_ font: UIFont, for range: NSRange? = nil) -> NSMutableAttributedString {
        addAttribute(.font, value: font, range: range ?? string.fullRange)
        return self
    }

    @discardableResult
    open func textAlignment(_ textAlignment: NSTextAlignment, lineSpacing: CGFloat = 0, for range: NSRange? = nil) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        addAttribute(.paragraphStyle, value: paragraphStyle, range: range ?? string.fullRange)
        return self
    }

    @discardableResult
    open func link(url: URL?, for range: NSRange? = nil) -> NSMutableAttributedString {
        guard let url = url else {
            return self
        }

        addAttribute(.link, value: url, range: range ?? string.fullRange)
        return self
    }
    
    @discardableResult
    open func indent(font: UIFont, color: UIColor, lineSpacing: CGFloat = 0, for range: NSRange) -> NSMutableAttributedString {
        return self.indent(color: color, lineSpacing: lineSpacing, for: [range])
    }
    
    @discardableResult
    open func indent(color: UIColor, lineSpacing: CGFloat = 0, for ranges: [NSRange]) -> NSMutableAttributedString {
        guard !ranges.isEmpty else { return self }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 21
        paragraphStyle.alignment = .left

        let indentString = AttributedTag.indent.replacingString
        let indentAttribute = NSAttributedString(string: indentString,
                                                 attributes: [.font: AttributedTag.indent.font(),
                                                              .foregroundColor: color])
        var offset = 0
        ranges.forEach { range in
            addAttributes([.paragraphStyle: paragraphStyle], range: range)
            insert(indentAttribute, at: range.location + offset)
            offset += indentString.count
        }
          
        return self
    }

    private func range(of text: String?) -> NSRange {
        let range: NSRange

        if let text = text {
            range = (string as NSString).range(of: text)
        } else {
            range = NSRange(location: 0, length: string.count)
        }

        return range
    }
}

extension NSAttributedString {
    /// Returns an `NSAttributedString` object initialized with a given `string` and `attributes`.
    ///
    /// Returns an `NSAttributedString` object initialized with the characters of `aString`
    /// and the attributes of `attributes`. The returned object might be different from the original receiver.
    ///
    /// - Parameters:
    ///   - string: The string for the new attributed string.
    ///   - image: The image for the new attributed string.
    ///   - baselineOffset: The value indicating the `image` offset from the baseline. The default value is `0`.
    ///   - attributes: The attributes for the new attributed string. For a list of attributes that you can include in this
    ///                 dictionary, see `Character Attributes`.
    public convenience init(string: String? = nil, image: UIImage, baselineOffset: CGFloat = 0, attributes: [Key: Any]? = nil) {
        let attachment = NSAttributedString.attachmentAttributes(for: image, baselineOffset: baselineOffset)

        guard let string = string else {
            self.init(string: attachment.string, attributes: attachment.attributes)
            return
        }

        let attachmentAttributedString = NSAttributedString(string: attachment.string, attributes: attachment.attributes)
        let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
        attributedString.append(attachmentAttributedString)
        self.init(attributedString: attributedString)
    }
    
    convenience init?(stringWithTag: String?, font: UIFont, color: UIColor, alignment: NSTextAlignment = .left, lineSpacing: CGFloat = 0, linkURLs: [String] = []) {
        guard let stringWithTag = stringWithTag else { return nil }
        let attributedString = NSMutableAttributedString(
            string: stringWithTag)
            .font(font).foregroundColor(color)
            .textAlignment(alignment)
        
        let attributedDict = stringWithTag.getAttributedRanges()
        attributedDict.forEach { (tag, ranges) in
            if tag.isFontAttribute {
                ranges.forEach { attributedString.font(tag.font(font.pointSize), for: $0) }
            }
            if tag.isColorAttribute {
                ranges.forEach { attributedString.foregroundColor(tag.foregroundColor, for: $0) }
            }
            if tag == .link {
                var URLs = linkURLs.map { URL(string: $0) }.compactMap { $0 }
                ranges.forEach {
                    let url = URLs.isEmpty ? nil : URLs.removeFirst()
                    attributedString.link(url: url, for: $0).underline(for: $0)
                }
            }
            if tag == .underline {
                ranges.forEach { attributedString.underline(for: $0) }
            }
        }
        
        if let indentRanges = attributedDict[.indent] { // Indentation MUST be handled last
            attributedString.indent(color: color, lineSpacing: lineSpacing, for: indentRanges)
        }
        
        attributedString.mutableString.replaceOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: NSRange(location: 0, length: attributedString.length))
        self.init(attributedString: attributedString)
    }

    private static func attachmentAttributes(for image: UIImage, baselineOffset: CGFloat) -> (string: String, attributes: [Key: Any]) {
        guard let paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            debugPrint("Cannot cast from NSParagraphStyle to NSMutableParagraphStyle")
            return (string: "", attributes: [:])
        }
        paragraphStyle.lineHeightMultiple = 0.9

        let attachment = NSTextAttachment(data: nil, ofType: nil)
        attachment.image = image

        let attachmentCharacterString = String(Character(UnicodeScalar(NSTextAttachment.character)!))

        return (string: attachmentCharacterString, attributes: [
            .attachment: attachment,
            .baselineOffset: baselineOffset,
            .paragraphStyle: paragraphStyle
        ])
    }
}

extension NSAttributedString {
    var fullRange: NSRange {
        return NSRange(location: 0, length: length)
    }

    func toStringWithTag() -> String {
        var convertedStrings = [String]()
        
        enumerateAttributes(in: fullRange, options: .longestEffectiveRangeNotRequired) { attributes, range, _ in
            var convertedString = string[range]
            
            if let font = attributes[.font] as? UIFont {
                if convertedString == AttributedTag.indent.replacingString {
                    convertedString = AttributedTag.indent.rawValue
                } else  if font.fontDescriptor.symbolicTraits.contains([.traitBold, .traitItalic]) {
                    convertedString = convertedString.adding(.boldItalic)
                } else if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    convertedString = convertedString.adding(.bold)
                } else if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    convertedString = convertedString.adding(.italic)
                }
            }
            if (attributes[.underlineStyle] as? NSUnderlineStyle) != nil {
                convertedString = convertedString.adding(.underline)
            }
            
            convertedStrings.append(convertedString)
        }
        
        return convertedStrings.joined()
    }
}
