import QtQuick 2.14
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
			rowSpacing: 4

			Repeater {
				model: metternich.selected_holding ? metternich.selected_holding.building_slots : []

				Item {
					property var building_slot: model.modelData
					property var tooltip_text: tooltip(highlight(building_slot.building.name)
						+ (building_slot.effects_string !== "" ? "<br><br>" + building_slot.effects_string : ""))

					width: building_area.width
					height: 32
					visible: building_slot.available && (building_slot.built || (metternich.game.player_character && metternich.game.player_character.can_build_in_holding(metternich.selected_holding)))

					Image {
						source: building_slot.icon_path
						width: 32
						height: 32
						anchors.left: parent.left
						anchors.leftMargin: 8
						anchors.verticalCenter: parent.verticalCenter

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip_text
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}

					Text {
						text: building_slot.building.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: 8 + 32 + 8
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
						font.bold: building_slot.built

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip_text
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}

					PanelButton {
						visible: metternich.game.player_character && metternich.game.player_character.can_build_in_holding(metternich.selected_holding) && metternich.selected_holding.under_construction_building === null && building_slot.buildable && !building_slot.built
						anchors.top: parent.top
						anchors.topMargin: 1
						anchors.bottom: parent.bottom
						anchors.bottomMargin: 1
						anchors.right: parent.right
						width: 64
						text: "<font color=\"black\">Build</font>"
						onClicked: {
							metternich.selected_holding.order_construction(building_slot.building)
							game_view.forceActiveFocus()
						}
					}

					Text {
						text: "Under Construction (" + metternich.selected_holding.construction_days + " days)"
						visible: metternich.selected_holding.under_construction_building === building_slot.building
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: "Built"
						visible: building_slot.built
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						anchors.rightMargin: 8
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}
				}
			}
		}
	}
}
