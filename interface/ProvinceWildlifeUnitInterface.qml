import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: wildlife_unit_area

	Flickable {
		anchors.fill: parent
		contentWidth: wildlife_unit_grid.width
		contentHeight: wildlife_unit_grid.height
		clip: true
		interactive: false
		boundsBehavior: Flickable.StopAtBounds
		ScrollBar.vertical: ScrollBar {}

		Grid {
			id: wildlife_unit_grid
			columns: 1
			columnSpacing: 0
			rowSpacing: 4

			Repeater {
				model: metternich.selected_province ? metternich.selected_province.wildlife_units : []

				Item {
					width: wildlife_unit_area.width
					height: 32

					Image {
						source: model.modelData.icon_path
						width: 32
						height: 32
						anchors.left: parent.left
						anchors.leftMargin: 24
						anchors.verticalCenter: parent.verticalCenter
					}

					Text {
						text: model.modelData.species.name_plural
						anchors.verticalCenter: parent.verticalCenter
						anchors.left: parent.left
						anchors.leftMargin: parent.width / 4 + 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					Text {
						text: number_str(model.modelData.size)
						anchors.verticalCenter: parent.verticalCenter
						anchors.right: parent.right
						anchors.rightMargin: 24
						color: "black"
						font.pixelSize: 12
						font.family: "tahoma"
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true
						ToolTip.text: tooltip(model.modelData.species.name_plural + "<br>" + (model.modelData.clade ? "<br>Clade: " + model.modelData.clade.name : "") + "<br>Size: " + number_str(model.modelData.size) + "<br>Biomass: " + number_str(model.modelData.biomass))
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}
}
