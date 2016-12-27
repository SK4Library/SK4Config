//
//  SK4ConfigBool.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation
import SK4Library

/// Bool型の設定を管理するためのクラス
open class SK4ConfigBool: SK4ConfigGenerics<Bool> {

	/// BoolをStringに変換
	public static func boolToString(_ value: Bool) -> String {
		return value ? "Yes" : "No"
	}

	/// StringをBoolに変換
	public static func stringToBool(_ string: String) -> Bool {
		let str = string.trimmingSpaceNL().lowercased()
		if str == "yes" || str == "true" {
			return true
		} else {
			return false
		}
	}

	// /////////////////////////////////////////////////////////////

	/// 値と文字列を変換
	override open var string: String {
		get {
			return SK4ConfigBool.boolToString(value)
		}

		set {
			value = SK4ConfigBool.stringToBool(newValue)
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: Bool) {
		super.init(title: title, identifier: identifier, value: value)

		self.cell = SK4ConfigCellSwitch()
	}

	/// ランダムに変更
	override open func random() {
		if readOnly == false {
			if sk4Random(max: 2) == 0 {
				value = false
			} else {
				value = true
			}
		}
	}

	/// Boolを反転
	public func flip() {
		value = !value
	}

}

// eof
