import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
	id: cosmic_map
	width: 8192
	height: 8192
	
	function moveLeft(pixels) {
		cosmic_map.x += pixels * cosmic_map.scale
	}

	function moveRight(pixels) {
		cosmic_map.x -= pixels * cosmic_map.scale
	}

	function moveUp(pixels) {
		cosmic_map.y += pixels * cosmic_map.scale
	}

	function moveDown(pixels) {
		cosmic_map.y -= pixels * cosmic_map.scale
	}
	
	function astrocoordinate_to_pos(astrocoordinate, astrodistance) {
		return Qt.point(astrocoordinate.longitude * astrodistance / 100, (astrocoordinate.latitude * 2) * astrodistance / 100)
	}
	
	Rectangle {
		id: space_background
		anchors.fill: parent
		color: "black"

		MouseArea {
			anchors.fill: parent
			onClicked: {
				if (metternich.selected_province !== null) {
					metternich.selected_province.selected = false
				}
				if (metternich.selected_holding !== null) {
					metternich.selected_holding.selected = false
				}
				metternich.selected_character = null
			}
		}

		Repeater {
			model: metternich.worlds
			
			Rectangle {
				x: astrocoordinate_to_pos(model.modelData.astrocoordinate, model.modelData.astrodistance).x + (cosmic_map.width / 2) - (width / 2)
				y: astrocoordinate_to_pos(model.modelData.astrocoordinate, model.modelData.astrodistance).y + (cosmic_map.height / 2) - (height / 2)
				width: 64
				height: 64
				color: "brown"
				radius: width * 0.5
				
				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					ToolTip.text: tooltip(model.modelData.name)
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
					onClicked: {
						if (metternich.selected_holding) {
							metternich.selected_holding.selected = false
						}
						if (model.modelData.selectable) {
							model.modelData.selected = true
						} else if (metternich.selected_province) {
							metternich.selected_province.selected = false
						}
						metternich.selected_character = null
					}
				}
			}
		}
	}
}
