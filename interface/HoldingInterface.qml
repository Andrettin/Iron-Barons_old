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

	Item {
		id: building_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: population_capacity_area.bottom
		anchors.topMargin: 32
		height: 128

		Flickable {
			anchors.fill: parent
			contentWidth: building_grid.width
			contentHeight: building_grid.height
			clip: true
			interactive: false
			boundsBehavior: Flickable.StopAtBounds
			ScrollBar.vertical: ScrollBar {}

			Grid {
				id: building_grid
				columns: 1
				columnSpacing: 0
				rowSpacing: 0

				Repeater {
					model: Metternich.selected_holding ? Metternich.selected_holding.available_buildings : []

					Item {
						width: building_area.width
						height: 32

						Text {
							text: model.modelData.name
							anchors.verticalCenter: parent.verticalCenter
							anchors.left: parent.left
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
							font.bold: Metternich.selected_holding.buildings.includes(model.modelData)
						}

						Button {
							visible: Metternich.game.player_character.can_build_in_holding(Metternich.selected_holding) && Metternich.selected_holding.under_construction_building === null && !Metternich.selected_holding.buildings.includes(model.modelData)
							anchors.top: parent.top
							anchors.topMargin: 1
							anchors.bottom: parent.bottom
							anchors.bottomMargin: 1
							anchors.right: parent.right
							width: 64
							text: "<font color=\"black\">Build</font>"
							font.pixelSize: 12
							font.family: "tahoma"
							onClicked: Metternich.selected_holding.order_construction(model.modelData)
						}

						Text {
							text: "Under Construction (" + Metternich.selected_holding.construction_days + " days)"
							visible: Metternich.selected_holding.under_construction_building === model.modelData
							anchors.verticalCenter: parent.verticalCenter
							anchors.right: parent.right
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
						}

						Text {
							text: "Built"
							visible: Metternich.selected_holding.buildings.includes(model.modelData)
							anchors.verticalCenter: parent.verticalCenter
							anchors.right: parent.right
							color: "black"
							font.pixelSize: 12
							font.family: "tahoma"
						}
					}
				}
			}
		}
	}

	HoldingPopulationUnitInterface {
		id: population_unit_area
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		anchors.top: building_area.bottom
		anchors.topMargin: 32
		anchors.bottom: province_button.top
		anchors.bottomMargin: 8
	}

	Button {
		id: province_button
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		text: "<font color=\"black\">Province</font>"
		width: 64
		height: 32
		onClicked: Metternich.selected_holding.selected = false
	}
}
