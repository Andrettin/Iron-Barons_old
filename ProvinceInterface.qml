import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: province_interface
	width: 348
	height: 624

	Image {
		id: province_background
		source: "file:///" + Metternich.asset_import_path + "/gfx/interface/province_bg.dds"
	}

	Text {
		id: province_name
		text: Metternich.selected_province ? Metternich.selected_province.name : ""
		anchors.top: parent.top
		anchors.topMargin: 15
		anchors.left: parent.left
		anchors.leftMargin: 81
		color: "white"
		font.pixelSize: 14
		font.family: "tahoma"
	}

	Item {
		id: kingdom_area
		x: 17
		y: 267
		width: 153
		height: 32

		Text {
			id: province_de_jure_kingdom
			text: qsTr("Germany")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 31
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: duchy_area
		x: 17
		y: 300
		width: 153
		height: 32

		Text {
			id: province_de_jure_duchy
			text: qsTr("Austria")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 31
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: culture_area
		x: 17
		y: 333
		width: 153
		height: 13

		Text {
			id: culture_label
			text: qsTr("Culture")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_culture
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.culture.identifier) : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: religion_area
		x: 17
		y: 347
		width: 153
		height: 13

		Text {
			id: religion_label
			text: qsTr("Religion")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_religion
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.religion.identifier) : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: supply_area
		x: 17
		y: 361
		width: 153
		height: 13

		Text {
			id: supply_label
			text: qsTr("Supply")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_supply
			text: "10.0K"
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: revolt_risk_area
		x: 17
		y: 375
		width: 153
		height: 13

		Text {
			id: revolt_risk_label
			text: qsTr("Revolt Risk")
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.left: parent.left
			anchors.leftMargin: 4
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_revolt_risk
			text: "0.0%"
			anchors.verticalCenter: parent.verticalCenter
			anchors.verticalCenterOffset: -2
			anchors.right: parent.right
			anchors.rightMargin: 5
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}
}
