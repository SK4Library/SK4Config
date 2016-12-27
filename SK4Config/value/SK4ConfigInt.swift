//
//  SK4ConfigInt.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// Int型の設定を管理するためのクラス
open class SK4ConfigInt: SK4ConfigGenerics<Int> {

	/// 値と文字列を相互に変換
	override open var string: String {
		get {
			return String(value)
		}

		set {
			value = Int(newValue) ?? 0
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: Int) {
		super.init(title: title, identifier: identifier, value: value)
	}

}

// eof
