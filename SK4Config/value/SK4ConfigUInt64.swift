//
//  SK4ConfigUInt64.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import Foundation

/// UInt64型の設定を管理するためのクラス　※内部管理向け
public class SK4ConfigUInt64: SK4ConfigGenerics<UInt64> {

	/// 値と文字列を相互に変換
	override public var string: String {
		get {
			return String(format: "0x%016llx", value)
		}

		set {
			let scan = Scanner(string: newValue)
			scan.scanHexInt64(&value)
		}
	}

	/// 初期化
	override public init(title: String, identifier: String? = nil, value: UInt64) {
		super.init(title: title, identifier: identifier, value: value)
	}

}

// eof
