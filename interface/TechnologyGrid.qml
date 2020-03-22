import QtQuick 2.14
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.14

Flickable {
	id: technology_grid
	contentWidth: technology_area_list.width
	contentHeight: technology_area_list.height
	clip: true
	interactive: false
	boundsBehavior: Flickable.StopAtBounds
	ScrollBar.vertical: CustomScrollBar {}

	ColumnLayout {
		readonly property int columns: 8
		readonly property int columnSpacing: (width - (columns * 32)) / (columns - 1)

		id: technology_area_list
		width: technology_grid.width - 16 //-16 to leave space for the scrollbar
		spacing: 8

		Repeater {
			model: territory ? territory.technology_slots : []

			RowLayout {
				property var area_technology_slots: model.modelData

				id: technology_list
				spacing: technology_area_list.columnSpacing

				Repeater {
					model: area_technology_slots

					Image {
						property var technology_slot: model.modelData
						property var technology: technology_slot.technology

						source: technology_slot.icon_path
						width: 32
						height: 32
						opacity: technology_slot.acquired ? 1 : 0.33
						Layout.fillWidth: false
						Layout.fillHeight: false

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip(highlight(technology.name)
								+ "<br><br>Category: " + technology.area.category_name
								+ "<br>Area: " + technology.area.name
								+ "<br>Level: " + (technology.level + 1)
								+ (technology_slot.required_technologies_string !== "" ? "<br>" + technology_slot.required_technologies_string : "")
								+ (technology_slot.effects_string !== "" ? "<br>" + technology_slot.effects_string : ""))
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}
				}
			}
		}
	}
}
