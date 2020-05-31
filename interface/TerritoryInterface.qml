import QtQuick 2.14
import QtQuick.Controls 2.5

Item {
	width: 352 * scale_factor
	height: 640 * scale_factor
	
	property var territory: null
	readonly property var population_area: population_area
	readonly property var holding_interface: holding_interface

	enum Mode {
		Settlements,
		Palaces,
		Other,
		Technologies,
		Wildlife
	}

	property real holding_area_y: holding_area.y
	property int mode: TerritoryInterface.Mode.Settlements

	PanelBackground {
		anchors.fill: parent
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
	}

	Text {
		id: territory_name
		text: territory ? territory.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16 * scale_factor
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14 * scale_factor
		font.family: "tahoma"
		font.bold: true
	}

	Holding {
		id: capital_holding
		anchors.top: parent.top
		anchors.topMargin: 48 * scale_factor
		anchors.horizontalCenter: parent.horizontalCenter
		holding_slot: territory && territory.capital_holding_slot ? territory.capital_holding_slot : null
		imageWidth: 128 * scale_factor
		imageHeight: 128 * scale_factor
		visible: mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
	}

	PopulationTypeChart {
		id: population_type_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4 * scale_factor
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		visible: territory !== null && territory.settlement_holdings.length > 0 && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		dataSource: territory
	}

	CultureChart {
		id: culture_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4 * scale_factor
		anchors.horizontalCenter: parent.horizontalCenter
		visible: territory !== null && territory.settlement_holdings.length > 0 && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		dataSource: territory
	}

	ReligionChart {
		id: religion_chart
		anchors.top: capital_holding.bottom
		anchors.topMargin: 4 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		visible: territory !== null && territory.settlement_holdings.length > 0 && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		dataSource: territory
	}

	Item {
		id: empire_area
		visible: territory !== null && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		anchors.top: culture_chart.bottom
		anchors.topMargin: 16 * scale_factor

		Text {
			id: de_jure_empire_label
			text: qsTr("Empire")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_empire_flag
			landed_title: territory && territory.empire && territory.empire !== territory.de_jure_empire ? territory.empire : null
			anchors.right: empire_flag_separator.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: empire_flag_separator
			text: territory && territory.empire && territory.empire !== territory.de_jure_empire ? "/" : ""
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_empire_flag.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_empire_flag
			landed_title: territory && territory.de_jure_empire ? territory.de_jure_empire : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: kingdom_area
		visible: territory !== null && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		anchors.top: empire_area.bottom
		anchors.topMargin: 20 * scale_factor

		Text {
			id: de_jure_kingdom_label
			text: qsTr("Kingdom")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_kingdom_flag
			landed_title: territory && territory.kingdom && territory.kingdom !== territory.de_jure_kingdom ? territory.kingdom : null
			anchors.right: kingdom_flag_separator.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: kingdom_flag_separator
			text: territory && territory.kingdom && territory.kingdom !== territory.de_jure_kingdom ? "/" : ""
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_kingdom_flag.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_kingdom_flag
			landed_title: territory && territory.de_jure_kingdom ? territory.de_jure_kingdom : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: duchy_area
		visible: territory !== null && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		anchors.top: kingdom_area.bottom
		anchors.topMargin: 20 * scale_factor

		Text {
			id: de_jure_duchy_label
			text: qsTr("Duchy")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
		}

		LandedTitleFlag {
			id: de_facto_duchy_flag
			landed_title: territory && territory.duchy && territory.duchy !== territory.de_jure_duchy ? territory.duchy : null
			anchors.right: duchy_flag_separator.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		Text {
			id: duchy_flag_separator
			text: territory && territory.duchy && territory.duchy !== territory.de_jure_duchy ? "/" : ""
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
			font.bold: true
			anchors.right: de_jure_duchy_flag.left
			anchors.rightMargin: 4 * scale_factor
			anchors.verticalCenter: parent.verticalCenter
		}

		LandedTitleFlag {
			id: de_jure_duchy_flag
			landed_title: territory && territory.de_jure_duchy ? territory.de_jure_duchy : null
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
		}
	}

	Item {
		id: population_area
		anchors.topMargin: 20 * scale_factor
		anchors.left: parent.left
		anchors.leftMargin: 32 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 32 * scale_factor
		anchors.top: duchy_area.bottom
		visible: territory !== null && territory.settlement_holdings.length > 0 && mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies && metternich.selected_holding === null

		Text {
			id: population_label
			text: qsTr("Population")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
		}

		Text {
			id: territory_population
			text: territory ? number_str(territory.population) : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12 * scale_factor
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: holding_area
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8 * scale_factor
		anchors.left: parent.left
		anchors.leftMargin: 8 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 8 * scale_factor
		height: 193
		visible: mode !== TerritoryInterface.Mode.Wildlife && mode !== TerritoryInterface.Mode.Technologies

		HoldingGrid {
			id: settlement_holding_grid
			anchors.fill: parent
			visible: mode === TerritoryInterface.Mode.Settlements
			holding_model: territory ? territory.settlement_holding_slots : []
		}

		HoldingGrid {
			id: palace_holding_grid
			anchors.fill: parent
			visible: mode === TerritoryInterface.Mode.Palaces
			holding_model: territory ? territory.palace_holding_slots : []
		}

		HoldingGrid {
			id: extra_holding_grid
			anchors.fill: parent
			visible: mode === TerritoryInterface.Mode.Other
			holding_model: territory ? (territory.trading_post_holding_slot ? [territory.fort_holding_slot, territory.university_holding_slot, territory.hospital_holding_slot, territory.trading_post_holding_slot, territory.factory_holding_slot] : [territory.fort_holding_slot, territory.university_holding_slot, territory.hospital_holding_slot, territory.factory_holding_slot]) : []
		}
	}

	TechnologyGrid {
		anchors.left: parent.left
		anchors.leftMargin: 8 * scale_factor
		anchors.right: parent.right
		anchors.rightMargin: 8 * scale_factor
		anchors.top: parent.top
		anchors.topMargin: 48 * scale_factor
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8 * scale_factor
		visible: mode === TerritoryInterface.Mode.Technologies && metternich.selected_holding === null
	}

	HoldingInterface {
		id: holding_interface
		visible: metternich.selected_holding !== null
	}
}
