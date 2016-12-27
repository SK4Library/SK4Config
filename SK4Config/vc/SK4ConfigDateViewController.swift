//
//  SK4ConfigDateViewController.swift
//  SK4Config
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import UIKit
import SK4Library

/// UIDatePickerで日時を選択するためのViewController
class SK4ConfigDateViewController: UIViewController {

	var configValue: SK4ConfigValue!
	var datePicker: UIDatePicker!
	var dateLabel: UILabel!

	func onClose(sender: AnyObject) {
		_ = navigationController?.popViewController(animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// デフォルトのView
		view.backgroundColor = UIColor.white

		// UIDatePicker
		let picker = UIDatePicker()
		view.addSubview(picker)
		datePicker = picker

		// UILabel
		dateLabel = UILabel()
		dateLabel.textAlignment = .center
		view.addSubview(dateLabel)

		// UIButton
		let button = UIButton(type: .system)
		button.setTitle("OK", for: .normal)
		button.addTarget(self, action: #selector(SK4ConfigDateViewController.onClose(sender:)), for: .touchUpInside)
		view.addSubview(button)

		// AutoLayoutを設定
		let maker = SK4AutoLayout(viewController: self)
		maker.addDic(name: "picker", view: picker)
		maker.addDic(name: "button", view: button)
		maker.addDic(name: "label", view: dateLabel)

		maker.addFormat("V:[topLayoutGuide]-24-[label(==21)]-8-[picker(>=162)]-16-[button]")
		maker.addFormat("H:|-[label]-|")
		maker.addFormat("H:|-[picker]-|")
		maker.addFormat("H:[button(==120)]")
		maker.addCenterEqualX(target: button, base: view)

		view.addConstraints(maker.constraints)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		assert(configValue is SK4ConfigDate, "Wrong config type.")

		if let cv = configValue as? SK4ConfigDate {
			datePicker.date = cv.value
			datePicker.datePickerMode = cv.pickerMode

			if cv.annotation.isEmpty {
				dateLabel.text = cv.string
			} else {
				dateLabel.text = cv.annotation
			}
		}

		navigationItem.title = configValue.title
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if let cv = configValue as? SK4ConfigDate {
			cv.value = datePicker.date
		}
	}
}

// eof
