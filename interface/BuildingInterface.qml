import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: building_area

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
