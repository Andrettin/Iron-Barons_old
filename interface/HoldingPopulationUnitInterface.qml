import QtQuick 2.14
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
		ScrollBar.vertical: CustomScrollBar {}

		Grid {
			id: population_unit_grid
			columns: 1
			columnSpacing: 0
			rowSpacing: 4

			Repeater {
				model: metternich.selected_holding ? metternich.selected_holding.population_units : []

				Item {
					property var population_unit: model.modelData

					width: population_unit_area.width - 16 //-16 to provide some space for the scrollbar
					height: 32

					Image {
						source: population_unit.icon_path
						width: 32
						height: 32
						anchors.left: parent.left
						anchors.leftMargin: 8
						anchors.verticalCenter: parent.verticalCenter
					}

					Text {
						text: population_unit.culture.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: parent.width / 4 + 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: population_unit.religion.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: parent.width / 4 * 2 + 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: number_str(population_unit.size)
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						anchors.rightMargin: 8
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(population_unit.type.name
							+ "<br><br>Culture: " + population_unit.culture.name
							+ "<br>Religion: " + population_unit.religion.name
							+ "<br>Size: " + number_str(population_unit.size)
							+ "<br>Wealth: " + centesimal(population_unit.wealth)
							+ (population_unit.unemployed_size > 0 ? "<br>Unemployment: " + (population_unit.unemployed_size * 100 / population_unit.size).toLocaleString(Qt.locale("en_US"), 'f', 2) + "%" : "")
						)
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}
}
