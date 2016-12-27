//
//  SK4ConfigCell.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// 設定を操作するCellへの基底クラス
open class SK4ConfigCell {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// true: 読み取り専用
	public var readOnly = false

	/// 操作するSK4ConfigValue
	public weak var configValue: SK4ConfigValue!

	/// 管理するSK4ConfigTableAdmin
	public weak var configTable: SK4ConfigTableAdmin?

	/// UITableViewCellで使用するID
	public let cellId: String

	/// UITableViewCellで使用するaccessory
	public var accessoryType = UITableViewCellAccessoryType.none

	/// 初期化
	public init() {
		cellId = NSStringFromClass(type(of: self))
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - Cellの生成・設定

	/// 利用可能なCellを取得
	open func availableCell(for tableView: UITableView) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) {
			return cell
		} else {
			return createCell()
		}
	}

	/// Cellを作成
	open func createCell() -> UITableViewCell {
		return UITableViewCell(style: .value1, reuseIdentifier: cellId)
	}

	/// Cellの内容を設定
	open func setupCell(_ cell: UITableViewCell) {
		cell.textLabel?.text = configValue.title
		cell.detailTextLabel?.text = configValue.string

		if accessoryType == .disclosureIndicator && readOnly {
			cell.accessoryType = .none
		} else {
			cell.accessoryType = accessoryType
		}
	}

	/// Cellを更新
	open func updateCell() {
		if let indexPath = configValue.indexPath {
			configTable?.tableView.reloadRows(at: [indexPath], with: .automatic)
		}
	}

	// /////////////////////////////////////////////////////////////

	/// Cellが選択された
	open func onSelectCell(_ cell: UITableViewCell) {
	}

	/// Cellが表示される
	open func willDisplayCell(_ cell: UITableViewCell) {
	}

	/// 移動先のViewControllerを取得する　※readOnlyの場合は移動しない
	open func nextViewController() -> UIViewController? {
		return nil
	}

}

// eof
