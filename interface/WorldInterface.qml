import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: world_interface
	width: 306
	height: 576
	
	property var world: null

	//property real holding_area_y: holding_area.y
	property int mode: ProvinceInterface.Mode.Settlements

	PanelBackground {
		anchors.fill: parent
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
	}

	Text {
		id: world_name
		text: world ? world.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	/*
	Holding {
		id: capital_holding
		anchors.top: parent.top
		anchors.topMargin: 48
		anchors.horizontalCenter: parent.horizontalCenter
		holding_slot: province && province.capital_holding_slot ? province.capital_holding_slot : null
		imageWidth: 128
		imageHeight: 128
		visible: mode !== ProvinceInterface.Mode.Wildlife
	}

	PopulationTypeChart {
		id: population_type_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.left: parent.left
		anchors.leftMargin: 32
		visible: province !== null && province.settlement_holdings.length > 0 && mode !== ProvinceInterface.Mode.Wildlife
		dataSource: province
	}

	CultureChart {
		id: culture_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.horizontalCenter: parent.horizontalCenter
		visible: province !== null && province.settlement_holdings.length > 0 && mode !== ProvinceInterface.Mode.Wildlife
		dataSource: province
	}

	ReligionChart {
		id: religion_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4
		anchors.right: parent.right
		anchors.rightMargin: 32
		visible: province !== null && province.settlement_holdings.length > 0 && mode !== ProvinceInterface.Mode.Wildlife
		dataSource: province
	}
	*/

	Item {
		id: empire_area
		visible: world !== null && mode !== ProvinceInterface.Mode.Wildlife
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		//anchors.top: culture_chart.bottom
		anchors.top: world_name.bottom
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
			landed_title: world && world.empire && world.empire !== world.de_jure_empire ? world.empire : null
			anchors.right: empire_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: empire_flag_separator
			text: world && world.empire && world.empire !== world.de_jure_empire ? "/" : ""
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
			landed_title: world && world.de_jure_empire ? world.de_jure_empire : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: kingdom_area
		visible: world !== null && mode !== ProvinceInterface.Mode.Wildlife
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
			landed_title: world && world.kingdom && world.kingdom !== world.de_jure_kingdom ? world.kingdom : null
			anchors.right: kingdom_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: kingdom_flag_separator
			text: world && world.kingdom && world.kingdom !== world.de_jure_kingdom ? "/" : ""
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
			landed_title: world && world.de_jure_kingdom ? world.de_jure_kingdom : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: duchy_area
		visible: world !== null && mode !== ProvinceInterface.Mode.Wildlife
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
			landed_title: world && world.duchy && world.duchy !== world.de_jure_duchy ? world.duchy : null
			anchors.right: duchy_flag_separator.left
			anchors.rightMargin: 4
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: duchy_flag_separator
			text: world && world.duchy && world.duchy !== world.de_jure_duchy ? "/" : ""
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
			landed_title: world && world.de_jure_duchy ? world.de_jure_duchy : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	/*
	Item {
		id: population_area
		anchors.topMargin: 20
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: duchy_area.bottom
		visible: province !== null && province.settlement_holdings.length > 0 && mode !== ProvinceInterface.Mode.Wildlife

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
			text: province ? number_str(province.population) : ""
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
		anchors.top: mode !== ProvinceInterface.Mode.Wildlife ? population_area.bottom : parent.top
		anchors.topMargin: mode !== ProvinceInterface.Mode.Wildlife ? 20 : 64
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32

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
			text: province ? province.terrain.name : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}
	*/

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

	/*
	Item {
		id: holding_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		width: 290
		height: 193
		visible: mode !== ProvinceInterface.Mode.Wildlife && mode !== ProvinceInterface.Mode.Technologies

		HoldingGrid {
			id: settlement_holding_grid
			anchors.fill: parent
			visible: mode === ProvinceInterface.Mode.Settlements
			holding_model: province ? province.settlement_holding_slots : []
		}

		HoldingGrid {
			id: palace_holding_grid
			anchors.fill: parent
			visible: mode === ProvinceInterface.Mode.Palaces
			holding_model: province ? province.palace_holding_slots : []
		}

		HoldingGrid {
			id: extra_holding_grid
			anchors.fill: parent
			visible: mode === ProvinceInterface.Mode.Other
			holding_model: province ? (province.trading_post_holding_slot ? [province.fort_holding_slot, province.university_holding_slot, province.hospital_holding_slot, province.trading_post_holding_slot, province.factory_holding_slot] : [province.fort_holding_slot, province.university_holding_slot, province.hospital_holding_slot, province.factory_holding_slot]) : []
		}
	}

	Flickable {
		id: technology_area
		anchors.left: parent.left
		anchors.leftMargin: 16
		anchors.right: parent.right
		anchors.rightMargin: 16
		anchors.top: terrain_area.bottom
		anchors.topMargin: 16
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		contentWidth: technology_grid.width
		contentHeight: technology_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}
		visible: mode === ProvinceInterface.Mode.Technologies

		Grid {
			id: technology_grid
			columns: 7
			columnSpacing: 4
			rowSpacing: 4

			Repeater {
				model: province ? province.technologies : []

				Image {
					source: model.modelData.icon_path
					width: 32
					height: 32

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(model.modelData.name)
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}

	ProvinceWildlifeUnitInterface {
		id: wildlife_unit_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: terrain_area.bottom
		anchors.topMargin: 24
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		visible: mode === ProvinceInterface.Mode.Wildlife
	}

	HoldingInterface {
		visible: metternich.selected_holding !== null
	}
	*/
}
