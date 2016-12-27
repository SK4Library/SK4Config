//
//  SK4ConfigCellTextField.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextField

/// 設定をUITextFieldで編集　※短い文に対応
public class SK4ConfigCellTextField: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let ctrlFrame = CGRect(x: 152, y: 7, width: 158, height: 30)
		static let disableTextColor = UIColor(white: 0.75, alpha: 1.0)
	}

	let textFieldAdmin = SK4ConfigCellTextFieldAdmin()

	/// 文字列の最大長　※0の時は文字列長の制限をしない
	public var maxLength = 0

	/// 文字列の最大長を指定して初期化
	public convenience init(maxLength: Int) {
		self.init()
		self.maxLength = maxLength
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
		let tf = UITextField(frame: Const.ctrlFrame)
		tf.tag = Const.ctrlTag
		tf.borderStyle = .roundedRect
		tf.clearButtonMode = .whileEditing
		tf.textAlignment = .right
		tf.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
		cell.contentView.addSubview(tf)
		return cell
	}

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title

		let tf = cell.contentView.viewWithTag(Const.ctrlTag) as! UITextField
		tf.removeAllTarget()

		textFieldAdmin.setup(textField: tf, maxLength: maxLength, configCell: self)

		tf.text = configValue.string
		if readOnly {
			tf.isEnabled = false
			tf.textColor = Const.disableTextColor
		} else {
			tf.isEnabled = true
			tf.textColor = nil
		}
	}

}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextFieldAdmin

/// SK4ConfigCellTextField専用のUITextField管理クラス
class SK4ConfigCellTextFieldAdmin: SK4TextFieldAdmin {

	weak var configCell: SK4ConfigCellTextField!

	var keepAlignment = NSTextAlignment.left

	/// 再設定
	func setup(textField: UITextField, maxLength: Int, configCell: SK4ConfigCellTextField) {
		super.setup(textField: textField, maxLength: maxLength)

		self.configCell = configCell
	}

	/// 文字列が変更された
	override func onAction(_ sender: UIControl) {
		super.onAction(sender)

		if let tf = sender as? UITextField {
			configCell.configValue.string = tf.text ?? ""
		}
	}

	/// テキストの編集開始
	override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		keepAlignment = textField.textAlignment
		textField.textAlignment = .left

		configCell.configTable?.setDisplayOffset(config: configCell.configValue)
		return true
	}

	/// テキストの編集終了
	override func textFieldDidEndEditing(_ textField: UITextField) {
		configCell.configTable?.setDisplayOffset(config: nil)

		textField.textAlignment = keepAlignment

		let str = configCell.configValue.string
		if textField.text != str {
			textField.text = str
		}
	}

}

// eof
