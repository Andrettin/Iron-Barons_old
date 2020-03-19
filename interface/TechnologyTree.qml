import QtQuick 2.14
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.14

Flickable {
	id: technology_tree
	contentWidth: technology_grid.width
	contentHeight: technology_grid.height
	clip: true
	interactive: false
	boundsBehavior: Flickable.StopAtBounds
	ScrollBar.vertical: CustomScrollBar {}

	GridLayout {
		id: technology_grid
		columns: 8
		width: technology_tree.width - 16 //to leave space for the scrollbar
		columnSpacing: (width - (columns * 32)) / (columns - 1)
		rowSpacing: 32

		Repeater {
			model: metternich.technologies

			Image {
				property var technology: model.modelData

				source: technology.icon_path
				width: 32
				height: 32
				opacity: (territory && territory.technologies.includes(technology)) ? 1 : 0.5
				Layout.fillWidth: false
				Layout.fillHeight: false
				Layout.row: technology.row
				Layout.column: technology.column

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					ToolTip.text: tooltip(highlight(technology.name)
						+ "<br><br>Category: " + technology.category_name)
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
				}

				Component.onCompleted: {
					if (technology.column >= technology_grid.columns) {
						technology_grid.columns = technology.column + 1
					}
				}
			}
		}
	}
}
