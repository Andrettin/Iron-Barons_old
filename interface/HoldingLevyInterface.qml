import QtQuick 2.14
import QtQuick.Controls 2.5

Item {
	id: levy_area

	Flickable {
		anchors.fill: parent
		contentWidth: levy_grid.width
		contentHeight: levy_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}

		Grid {
			id: levy_grid
			columns: 1
			columnSpacing: 0
			rowSpacing: 4

			Repeater {
				model: metternich.selected_holding ? metternich.selected_holding.levies : []

				Item {
					property var levy: model.modelData
					property var troop_stats: metternich.selected_holding.troop_stats[index]
					property var tooltip_text: tooltip(highlight(levy.type.name)
						+ "<br><br>Levy: " + number_str(levy.size)
						+ "<br>Attack: " + centesimal(troop_stats.attack)
						+ "<br>Defense: " + centesimal(troop_stats.defense))

					width: levy_area.width
					height: 32

					Image {
						id: levy_icon
						source: levy.type.icon_path
						width: 32
						height: 32
						anchors.left: parent.left
						anchors.leftMargin: 24
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
						text: levy.type.name
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: levy_icon.right
						anchors.leftMargin: 32
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip_text
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}

					Text {
						text: number_str(levy.size)
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						anchors.rightMargin: 8
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"

						MouseArea {
							anchors.fill: parent
							hoverEnabled: true
							ToolTip.text: tooltip_text
							ToolTip.visible: containsMouse
							ToolTip.delay: 1000
						}
					}
				}
			}
		}
	}
}
