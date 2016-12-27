//
//  SK4ConfigDate.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit

/// Date型の設定を管理するためのクラス
public class SK4ConfigDate: SK4ConfigGenerics<Date> {

	/// 値と文字列を変換
	override public var string: String {
		get {
			return formatter.string(from: value)
		}

		set {
			value = formatter.date(from: newValue) ?? Date(timeIntervalSinceReferenceDate: 0)
		}
	}

	/// 日時の変換に使うNSDateFormatter
	public var formatter = DateFormatter()

	/// DatePickerで日時を選択する時の説明
	public var annotation = ""

	/// DatePickerで日時を選択する時のモード
	public var pickerMode = UIDatePickerMode.date {
		didSet {
			setupFormatterStyle()
		}
	}

	/// 初期化
	public init(title: String, identifier: String? = nil, value: Date, pickerMode: UIDatePickerMode) {
		super.init(title: title, identifier: identifier, value: value)

		self.pickerMode = pickerMode
		setupFormatterStyle()

		self.defaultValue = self.string
		self.changeToCell = true
		self.cell = SK4ConfigCellDate()
	}

	func setupFormatterStyle() {
		switch pickerMode {
		case .time:
			formatter.dateStyle = .none
			formatter.timeStyle = .short

		case .date:
			formatter.dateStyle = .medium
			formatter.timeStyle = .none

		case .dateAndTime:
			formatter.dateStyle = .short
			formatter.timeStyle = .short

		case .countDownTimer:
			formatter.dateStyle = .none
			formatter.timeStyle = .short
		}
	}

}

// eof
