//
//  ConfigAdminTests.swift
//  SK4Toolkit
//
//  Created by See.Ku on 2016/03/31.
//  Copyright (c) 2016 AxeRoad. All rights reserved.
//

import XCTest
import SK4Config

class ConfigAdminTests: XCTestCase {

	func testAdmin1() {
		let admin1 = SK4ConfigAdmin(title: "test admin", identifier: "Admin1")
		XCTAssert(admin1.title == "test admin")
		XCTAssert(admin1.identifier == "Admin1")

		let cv1 = SK4ConfigInt(title: "Int1", value: 100)
		let cv2 = SK4ConfigInt(title: "Int2", value: 200)
		let cv3 = SK4ConfigInt(title: "Int3", value: 300)

		let sec1 = admin1.addSection(header: "header", footer: "footer", identifier: "Sec1")
		XCTAssert(sec1.identifier == "Sec1")
		XCTAssert(sec1.header == "header")
		XCTAssert(sec1.footer == "footer")

		sec1.addConfig(cv1)
		sec1.addConfig(cv2)

		let hide = admin1.hideSection
		hide.addConfig(cv3)
		XCTAssert(hide.identifier == "###hide###")

		XCTAssert(cv1.configAdmin === admin1)
		XCTAssert(cv2.configAdmin === admin1)
		XCTAssert(cv3.configAdmin === admin1)
		XCTAssert(adminDesc(admin1) == "/Admin1/Sec1|Int1: 100\n/Admin1/Sec1|Int2: 200\n/Admin1/###hide###|Int3: 300\n")

		// push/pop　※内部設定用のセクションには影響しない
		admin1.push()
		cv1.value = 111
		cv2.value = 222
		cv3.value = 333
		XCTAssert(adminDesc(admin1) == "/Admin1/Sec1|Int1: 111\n/Admin1/Sec1|Int2: 222\n/Admin1/###hide###|Int3: 333\n")

		admin1.pop()
		XCTAssert(adminDesc(admin1) == "/Admin1/Sec1|Int1: 100\n/Admin1/Sec1|Int2: 200\n/Admin1/###hide###|Int3: 333\n")

		// reset　※内部設定用のセクションには影響しない
		cv1.value = 1110
		cv2.value = 2220
		cv3.value = 3330
		XCTAssert(adminDesc(admin1) == "/Admin1/Sec1|Int1: 1110\n/Admin1/Sec1|Int2: 2220\n/Admin1/###hide###|Int3: 3330\n")

		admin1.reset()
		XCTAssert(adminDesc(admin1) == "/Admin1/Sec1|Int1: 100\n/Admin1/Sec1|Int2: 200\n/Admin1/###hide###|Int3: 3330\n")

		let admin2 = SK4ConfigAdmin()
		XCTAssert(admin2.title == "Admin")
		XCTAssert(admin2.identifier == "Admin")
	}

	func testAdminDir() {
		let root = SK4ConfigAdmin(title: "root")
		let sec1 = root.addSection(header: "Section1")
		let cv1 = SK4ConfigInt(title: "Int1", value: 100)
		sec1.addConfig(cv1)

		let sub = SK4ConfigAdmin(title: "sub")
		let sec2 = sub.addSection(header: "Section2")
		let cv2 = SK4ConfigInt(title: "Int2", value: 200)
		sec2.addConfig(cv2)

		sec1.addConfig(sub)
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")

		// push/pop　※内部設定用のセクションには影響しない
		root.push()
		cv1.value = 111
		sub.value = "aaa"
		cv2.value = 222
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 111\n/root/Section1|sub: aaa\n/root/Section1/sub/Section2|Int2: 222\n")

		root.pop()
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")

		// reset
		root.push()
		cv1.value = 111
		sub.value = "aaa"
		cv2.value = 222
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 111\n/root/Section1|sub: aaa\n/root/Section1/sub/Section2|Int2: 222\n")

		root.reset()
		XCTAssert(adminDesc(root) == "/root/Section1|Int1: 100\n/root/Section1|sub: \n/root/Section1/sub/Section2|Int2: 200\n")
	}


	func adminDesc(_ admin: SK4ConfigAdmin) -> String {
		var desc = ""
		admin.forAllConfig { path, cv in
			desc += "\(path)|\(cv)\n"
		}
		return desc
	}

}

// eof
