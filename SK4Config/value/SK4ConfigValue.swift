//
//  SK4ConfigValue.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/30.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// 設定を管理するための基底クラス
open class SK4ConfigValue: CustomStringConvertible, Equatable {

	// /////////////////////////////////////////////////////////////
	// MARK: - プロパティ＆初期化

	/// 名称（主にGUIで使用）
	public var title = ""

	/// ID（値の保管／復元で使用）
	public var identifier = ""

	/// 値と文字列を相互に変換
	open var string: String {
		get {
			assertionFailure("You need override me!")
			return ""
		}

		set {
			assertionFailure("You need override me!")
		}
	}

	/// true: 表示専用　※表示専用の場合、保存の対象にならない
	open var readOnly: Bool {
		get {
			return cell.readOnly
		}

		set {
			cell.readOnly = newValue
		}
	}

	/// この設定が所属する管理クラス
	public weak var configAdmin: SK4ConfigAdmin?

	/// 自分自身の位置を示すIndexPath
	public var indexPath: IndexPath? {
		return configAdmin?.indexPath(for: self)
	}

	/// 設定に対する操作
	public var cell: SK4ConfigCell {
		didSet {
			cell.configValue = self
		}
	}

	/// 初期化
	public init(title: String, identifier: String? = nil) {
		self.title = title
		self.identifier = identifier ?? title

		self.cell = SK4ConfigCellLabel()
		self.cell.configValue = self
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - その他

	/// push/popで使用する値
	public var keepValue = ""

	/// 初期値
	public var defaultValue = ""

	/// 値を保存
	open func push() {
		keepValue = string
	}

	/// 値を復元
	open func pop() {
		string = keepValue
	}

	/// 初期値に戻す
	open func reset() {
		string = defaultValue
	}

	/// ランダムに変更
	open func random() {
		// do nothing.
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for CustomStringConvertible

	open var description: String {
		return "\(title): \(string)"
	}

	// /////////////////////////////////////////////////////////////
	// MARK: - for Equatable

	public static func ==(lhs: SK4ConfigValue, rhs: SK4ConfigValue) -> Bool {
		return lhs === rhs
	}

}

// eof
