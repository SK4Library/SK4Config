//
//  SK4ConfigCellTextView.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextView

/// 設定をUITextViewで編集　※ある程度長めの文に対応
public class SK4ConfigCellTextView: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
		static let ctrlFrame = CGRect(x: 15, y: 12, width: 297, height: 20)
	}

	let textViewAdmin = SK4ConfigCellTextViewAdmin()

	/// 文字列の最大長　※0: 文字列長の制限をしない
	public var maxLength = 0

	/// 文字列の最大長を指定して初期化
	public convenience init(maxLength: Int) {
		self.init()
		self.maxLength = maxLength
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: cellId)

		let tv = UITextView(frame: Const.ctrlFrame)
		tv.tag = Const.ctrlTag
		tv.returnKeyType = .done
		tv.isScrollEnabled = false

		// UILabelと同じような設定にしておく
		tv.font = .systemFont(ofSize: 17)
		tv.textContainer.lineFragmentPadding = 0
		tv.textContainerInset = .zero
		cell.contentView.addSubview(tv)

		// 親Viewと四方の間隔を保つ制約を生成
		let maker = SK4AutoLayout()
		maker.addKeepMargin(name: "tv", view: tv)
		cell.contentView.addConstraints(maker.constraints)

		// 元のラベルをプレースホルダーに使う
		cell.textLabel?.textColor = .gray

		return cell
	}

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		tableCell = cell

		let tv = cell.contentView.viewWithTag(Const.ctrlTag) as! UITextView
		textViewAdmin.setup(textView: tv, maxLength: maxLength)
		textViewAdmin.configCell = self

		tv.text = configValue.string
		tv.isEditable = !readOnly

		dispPlaceholder()
	}

	/// Cellが選択された
	override public func onSelectCell(_ cell: UITableViewCell) {
		let tv = cell.contentView.viewWithTag(Const.ctrlTag) as! UITextView
		tv.becomeFirstResponder()
	}

	/// Cellの高さを再計算する
	func calcCellHeight(textView: UITextView) {
		let prev = textView.bounds.size
		let size = CGSize(width: prev.width, height: CGFloat.greatestFiniteMagnitude)
		let next = textView.sizeThatFits(size)

		if prev.height != next.height {
			UIView.setAnimationsEnabled(false)
			configTable?.tableView.beginUpdates()
			configTable?.tableView.endUpdates()
			UIView.setAnimationsEnabled(true)
		}
	}

	weak var tableCell: UITableViewCell?

	/// 元々のラベルをプレースホルダーとして使用
	func dispPlaceholder() {
		let str = configValue.string.isEmpty ? configValue.title : ""
		tableCell?.textLabel?.text = str
	}

	/// 入力中はプレースホルダーを非表示に
	func hidePlaceholder() {
		tableCell?.textLabel?.text = ""
	}

}


// /////////////////////////////////////////////////////////////
// MARK: - SK4ConfigCellTextView

/// SK4ConfigCellTextView専用のUITextView管理クラス
class SK4ConfigCellTextViewAdmin: SK4TextViewAdmin {

	weak var configCell: SK4ConfigCellTextView!

	/// テキストの編集開始
	func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		configCell.hidePlaceholder()
		configCell.configTable?.setDisplayOffset(config: configCell.configValue)
		return true
	}

	/// テキストの編集終了
	func textViewDidEndEditing(_ textView: UITextView) {
		configCell.configTable?.setDisplayOffset(config: nil)
		let str = configCell.configValue.string
		if textView.text != str {
			textView.text = str
		}
		configCell.dispPlaceholder()
	}

	/// テキストが編集された
	override func textViewDidChange(_ textView: UITextView) {

		// 日本語の変換中は他の処理なし
		if textView.markedTextRange != nil {
			configCell.calcCellHeight(textView: textView)
			return
		}

		let sel = textView.selectedTextRange
		var done = false

		// 改行が入力されたか？
		if let enter = textView.text.range(of: "\n") {
			textView.text.replaceSubrange(enter, with: "")
			done = true
		}

		// 必要であれば、文字列の長さを制限する
		if maxLength > 0 {
			if let len = textView.text?.characters.count, len > maxLength {
				textView.text = textView.text?.substring(to: maxLength)
			}
		}

		textView.selectedTextRange = sel
		configCell.configValue.string = textView.text

		if done {

			// 編集を終了
			textView.resignFirstResponder()
		} else {

			// Cellの高さを確認
			configCell.calcCellHeight(textView: textView)
		}
	}

}

// eof
