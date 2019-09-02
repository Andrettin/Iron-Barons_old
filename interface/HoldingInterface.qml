import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: holding_interface
	anchors.fill: parent

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
		id: holding_name
		text: Metternich.selected_holding ? Metternich.selected_holding.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Item {
		id: population_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: parent.top
		anchors.topMargin: 64

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
			id: holding_population
			text: Metternich.selected_holding ? Metternich.selected_holding.population : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: population_growth_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: population_area.bottom
		anchors.topMargin: 16

		Text {
			id: population_growth_label
			text: qsTr("Population Growth (monthly)")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: holding_population_growth
			text: Metternich.selected_holding ? (centesimal(Metternich.selected_holding.population_growth) + "%") : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	Item {
		id: population_capacity_area
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		anchors.top: population_growth_area.bottom
		anchors.topMargin: 16

		Text {
			id: population_capacity_label
			text: qsTr("Population Capacity")
			anchors.verticalCenter: parent.verticalCenter
			anchors.left: parent.left
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
		}

		Text {
			id: holding_population_capacity
			text: Metternich.selected_holding ? Metternich.selected_holding.population_capacity : ""
			anchors.verticalCenter: parent.verticalCenter
			anchors.right: parent.right
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			font.bold: true
		}
	}

	BuildingInterface {
		id: building_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 96
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8
	}

	HoldingPopulationUnitInterface {
		id: population_unit_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 96
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8
		visible: false
	}

	Button {
		id: buildings_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: province_button.left
		anchors.rightMargin: 8
		text: "<font color=\"black\">Buildings</font>"
		width: 80
		height: 32
		visible: !building_area.visible
		font.pixelSize: 12
		onClicked: {
			building_area.visible = true
			population_unit_area.visible = false
		}
	}

	Button {
		id: population_units_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.right: province_button.left
		anchors.rightMargin: 8
		text: "<font color=\"black\">Population</font>"
		width: 80
		height: 32
		font.pixelSize: 12
		visible: !population_unit_area.visible
		onClicked: {
			population_unit_area.visible = true
			building_area.visible = false
		}
	}

	Button {
		id: province_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "<font color=\"black\">Province</font>"
		width: 80
		height: 32
		font.pixelSize: 12
		onClicked: Metternich.selected_holding.selected = false
	}
}
