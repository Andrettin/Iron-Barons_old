import QtQuick 2.12
import QtQuick.Controls 2.5

TerritoryInterface {
	property var province: null
	territory: province

	Item {
		id: terrain_area
		anchors.top: mode !== TerritoryInterface.Mode.Wildlife ? population_area.bottom : parent.top
		anchors.topMargin: mode !== TerritoryInterface.Mode.Wildlife ? 20 : 64
		anchors.left: parent.left
		anchors.leftMargin: 32
		anchors.right: parent.right
		anchors.rightMargin: 32
		visible: metternich.selected_holding === null

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
		visible: mode === TerritoryInterface.Mode.Technologies && metternich.selected_holding === null

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
		visible: mode === TerritoryInterface.Mode.Wildlife && metternich.selected_holding === null
	}
}
