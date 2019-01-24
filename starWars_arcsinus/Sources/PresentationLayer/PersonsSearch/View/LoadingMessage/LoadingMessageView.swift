//
//  LoadingMessageView.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class LoadingMessageView: UIView {
  
  @IBOutlet private var activityIndicator: UIActivityIndicatorView!
  @IBOutlet private var messageLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    messageLabel.text = LocalizedString.
  }
  
}

extension LoadingMessageView: NibLoadable { }
