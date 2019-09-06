import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: population_unit_area

	Flickable {
		anchors.fill: parent
		contentWidth: population_unit_grid.width
		contentHeight: population_unit_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}

		Grid {
			id: population_unit_grid
			columns: 1
			columnSpacing: 0
			rowSpacing: 0

			Repeater {
				model: metternich.selected_holding ? metternich.selected_holding.population_units : []

				Item {
					width: population_unit_area.width
					height: 32

					Text {
						text: model.modelData.type.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
						font.bold: true
					}

					Text {
						text: model.modelData.culture.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: parent.width / 4 + 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: model.modelData.religion.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: parent.width / 4 * 2 + 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: model.modelData.size
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
