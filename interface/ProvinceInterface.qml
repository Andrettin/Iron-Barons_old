import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: province_interface
	width: 306
	height: 576
	
	enum HoldingAreaMode {
		Settlements,
		Palaces,
		Other
	}

	property real holding_area_y: holding_area.y
	property int holding_area_mode: ProvinceInterface.HoldingAreaMode.Settlements

	Rectangle {
		id: province_background
		anchors.fill: parent
		color: "darkGray"
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
	}

	Text {
		id: province_name
		text: metternich.selected_province ? metternich.selected_province.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Holding {
		id: capital_holding
		anchors.top: parent.top
		anchors.topMargin: 48
		anchors.horizontalCenter: parent.horizontalCenter
		holding_slot: metternich.selected_province ? metternich.selected_province.capital_holding.slot : null
		imageWidth: 128
		imageHeight: 128
	}

	PopulationTypeChart {
		id: population_type_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.left: parent.left
		anchors.leftMargin: 32
		dataSource: metternich.selected_province
	}

	CultureChart {
		id: culture_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.horizontalCenter: parent.horizontalCenter
		dataSource: metternich.selected_province
	}

	ReligionChart {
		id: religion_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.right: parent.right
		anchors.rightMargin: 32
		dataSource: metternich.selected_province
	}

	Item {
		id: empire_area
		visible: metternich.selected_province
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: culture_chart.bottom
		anchors.topMargin: 16

		Text {
			id: de_jure_empire_label
			text: qsTr("Empire")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_empire_flag
			landed_title: metternich.selected_province && metternich.selected_province.empire && metternich.selected_province.empire !== metternich.selected_province.de_jure_empire ? metternich.selected_province.empire : null
			anchors.right: empire_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: empire_flag_separator
			text: metternich.selected_province && metternich.selected_province.empire && metternich.selected_province.empire !== metternich.selected_province.de_jure_empire ? "/" : ""
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_empire_flag.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_empire_flag
			landed_title: metternich.selected_province ? metternich.selected_province.de_jure_empire : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: kingdom_area
		visible: metternich.selected_province
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: empire_area.bottom
		anchors.topMargin: 20

		Text {
			id: de_jure_kingdom_label
			text: qsTr("Kingdom")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_kingdom_flag
			landed_title: metternich.selected_province && metternich.selected_province.kingdom && metternich.selected_province.kingdom !== metternich.selected_province.de_jure_kingdom ? metternich.selected_province.kingdom : null
			anchors.right: kingdom_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: kingdom_flag_separator
			text: metternich.selected_province && metternich.selected_province.kingdom && metternich.selected_province.kingdom !== metternich.selected_province.de_jure_kingdom ? "/" : ""
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_kingdom_flag.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_kingdom_flag
			landed_title: metternich.selected_province ? metternich.selected_province.de_jure_kingdom : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: duchy_area
		visible: metternich.selected_province
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: kingdom_area.bottom
		anchors.topMargin: 20

		Text {
			id: de_jure_duchy_label
			text: qsTr("Duchy")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_duchy_flag
			landed_title: metternich.selected_province && metternich.selected_province.duchy && metternich.selected_province.duchy !== metternich.selected_province.de_jure_duchy ? metternich.selected_province.duchy : null
			anchors.right: duchy_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: duchy_flag_separator
			text: metternich.selected_province && metternich.selected_province.duchy && metternich.selected_province.duchy !== metternich.selected_province.de_jure_duchy ? "/" : ""
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_duchy_flag.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_duchy_flag
			landed_title: metternich.selected_province ? metternich.selected_province.de_jure_duchy : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: population_area
		anchors.topMargin: 20
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: duchy_area.bottom

		Text {
			id: population_label
			text: qsTr("Population")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_population
			text: metternich.selected_province ? metternich.selected_province.population : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: terrain_area
		anchors.topMargin: 20
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: population_area.bottom

		Text {
			id: terrain_label
			text: qsTr("Terrain")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: province_terrain
			text: metternich.selected_province ? metternich.selected_province.terrain.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
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

	Item {
		id: holding_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		width: 290
		height: 193

		HoldingGrid {
			id: settlement_holding_grid
			anchors.fill: parent
			visible: holding_area_mode === ProvinceInterface.HoldingAreaMode.Settlements
			holding_model: metternich.selected_province ? metternich.selected_province.settlement_holding_slots : []
		}

		HoldingGrid {
			id: extra_holding_grid
			anchors.fill: parent
			visible: holding_area_mode === ProvinceInterface.HoldingAreaMode.Other
			holding_model: metternich.selected_province ? [metternich.selected_province.fort_holding_slot, metternich.selected_province.university_holding_slot, metternich.selected_province.hospital_holding_slot] : []
		}
	}

	HoldingInterface {
		visible: metternich.selected_holding !== null
	}
}
