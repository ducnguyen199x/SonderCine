//
//  PaginationCell.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit
import TinyConstraints

/// `PaginationCell` display pagination view.
final class PaginationCell: UITableViewCell {
  private let paging = PaginationControl()

  /// Init:
  required init?(coder: NSCoder) { fatalError() }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    contentView.backgroundColor = R.color.backgroundColor()
    contentView.addSubview(paging)
    paging.centerXToSuperview()
    paging.edgesToSuperview(excluding: [.left, .right], insets: .top(20) + .bottom(50))
  }

  func setPaging(_ paging: Paging, selectPage: @escaping (Int) -> Void) {
    self.paging.setPaging(paging, selectPage: selectPage)
  }
}
