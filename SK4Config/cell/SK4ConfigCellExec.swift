//
//  SK4ConfigCellExec.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 選択に合わせて処理を実行
/// Segueを使っての遷移／UIAlertControllerの表示／Closureの実行が可能
public class SK4ConfigCellExec: SK4ConfigCell {

	struct Const {
		static let ctrlTag = 1
	}

	var configAction: SK4ConfigAction! {
		return configValue as! SK4ConfigAction
	}

	/// 初期化
	override public init() {
		super.init()

		readOnly = true
	}

	/// Cellを作成
	override public func createCell() -> UITableViewCell {
		if isSingleAction() {
			return createSingleActionCell()
		} else {
			return UITableViewCell(style: .value1, reuseIdentifier: cellId)
		}
	}

	/// Cellの内容を設定
	override public func setupCell(_ cell: UITableViewCell) {
		if let label = cell.contentView.viewWithTag(Const.ctrlTag) as? UILabel {
			label.text = configValue.title
			label.textColor = configAction.textColor

		} else {
			cell.textLabel?.text = configValue.title
			cell.textLabel?.textColor = configAction.textColor
			cell.detailTextLabel?.text = configValue.string
			cell.accessoryType = configAction.segueId == nil ? .none : .disclosureIndicator
		}
	}

	/// Cellが選択された
	override public func onSelectCell(_ cell: UITableViewCell) {

		guard let vc = configTable?.parent else { return }

		// Segueを使って遷移
		if let id = configAction.segueId {
			vc.performSegue(withIdentifier: id, sender: configAction)
		}

		// UIAlertControllerを表示
		if let alert = configAction.alertController {
			vc.present(alert, animated: true, completion: nil)
		}

		// アクションを実行
		configAction.onAction?(vc)
	}

	// /////////////////////////////////////////////////////////////

	/// 単純に処理を実行するだけのアクションか？
	func isSingleAction() -> Bool {
		if accessoryType == .none && configValue.string.isEmpty && configAction.segueId == nil {
			return true
		} else {
			return false
		}
	}

	/// 単純なアクション向けのCellを生成
	func createSingleActionCell() -> UITableViewCell {
		let id = NSStringFromClass(type(of: self)) + "-Single"
		let cell = UITableViewCell(style: .default, reuseIdentifier: id)

		let label = UILabel(frame: cell.bounds)
		cell.contentView.addSubview(label)

		label.tag = Const.ctrlTag
		label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		label.textAlignment = .center
		return cell
	}

}

// eof
