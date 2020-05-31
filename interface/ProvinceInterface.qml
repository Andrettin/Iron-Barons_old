import QtQuick 2.14
import QtQuick.Controls 2.5

TerritoryInterface {
	property var province: null
	territory: province

	Item {
		id: terrain_area
		anchors.top: mode !== TerritoryInterface.Mode.Wildlife ? population_area.bottom : parent.top
		anchors.topMargin: mode !== TerritoryInterface.Mode.Wildlife ? 20 : 64
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		visible: metternich.selected_holding === null && mode !== TerritoryInterface.Mode.Technologies

		Text {
			id: terrain_label
			text: qsTr("Terrain")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
		}

		Text {
			id: province_terrain
			text: province ? province.terrain.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
			font.bold: true
		}
	}

	/*
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
	*/

	ProvinceWildlifeUnitInterface {
		id: wildlife_unit_area
		anchors.left: parent.left
		anchors.leftMargin: 8 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 8 * scale_factor
		anchors.top: terrain_area.bottom
		anchors.topMargin: 24 * scale_factor
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8 * scale_factor
		visible: mode === TerritoryInterface.Mode.Wildlife && metternich.selected_holding === null
	}
}
