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
				model: metternich.selected_holding ? metternich.selected_holding.building_slots : []

				Item {
					width: building_area.width
					height: 32
					visible: true//model.modelData.available

					Text {
						text: model.modelData.building.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
						font.bold: model.modelData.built
					}

					Button {
						visible: metternich.game.player_character.can_build_in_holding(metternich.selected_holding) && metternich.selected_holding.under_construction_building === null && model.modelData.buildable && !model.modelData.built
						anchors.top: parent.top
						anchors.topMargin: 1
						anchors.bottom: parent.bottom
						anchors.bottomMargin: 1
						anchors.right: parent.right
						width: 64
						text: "<font color=\"black\">Build</font>"
						font.pixelSize: 12
						font.family: "tahoma"
						onClicked: metternich.selected_holding.order_construction(model.modelData.building)
					}

					Text {
						text: "Under Construction (" + metternich.selected_holding.construction_days + " days)"
						visible: metternich.selected_holding.under_construction_building === model.modelData.building
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: "Built"
						visible: model.modelData.built
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
