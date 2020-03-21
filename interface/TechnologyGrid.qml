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
			model: metternich.technology_areas

			RowLayout {
				property var technology_area: model.modelData

				id: technology_list
				spacing: technology_area_list.columnSpacing

				Repeater {
					model: technology_area.technologies

					Image {
						property var technology: model.modelData

						source: technology.icon_path
						width: 32
						height: 32
						opacity: (territory && territory.technologies.includes(technology)) ? 1 : 0.5
						Layout.fillWidth: false
						Layout.fillHeight: false

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip(highlight(technology.name)
								+ "<br><br>Category: " + technology.area.category_name
								+ "<br>Area: " + technology.area.name)
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}
				}
			}
		}
	}
}
