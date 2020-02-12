import QtQuick 2.14
import QtQuick.Controls 2.14

Item {
	id: cosmic_map
	width: 16384
	height: 16384
	
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
	
	Rectangle {
		id: space_background
		anchors.fill: parent
		color: "black"

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			ToolTip.text: tooltip("(" + (mouseX - (width / 2)) + ", " + (mouseY - (height / 2)) + ")")
			ToolTip.visible: containsMouse
			ToolTip.delay: 1000
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

		Repeater { //orbits
			model: metternich.worlds
			
			Rectangle {
				visible: model.modelData.orbit_center !== null
				x: model.modelData.orbit_center ? model.modelData.orbit_center.cosmic_map_pos.x + (cosmic_map.width / 2) - (width / 2) : 0
				y: model.modelData.orbit_center ? model.modelData.orbit_center.cosmic_map_pos.y + (cosmic_map.height / 2) - (height / 2) : 0
				width: model.modelData.distance_from_orbit_center * 2
				height: model.modelData.distance_from_orbit_center * 2
				color: "transparent"
				border.color: "blue"
				border.width: 1
				radius: width * 0.5
			}
		}

		Repeater { //the worlds themselves
			model: metternich.worlds

			Rectangle {
				x: model.modelData.cosmic_map_pos.x + (cosmic_map.width / 2) - (width / 2)
				y: model.modelData.cosmic_map_pos.y + (cosmic_map.height / 2) - (height / 2)
				width: model.modelData.cosmic_pixel_size
				height: model.modelData.cosmic_pixel_size
				color: "brown"
				radius: width * 0.5
				visible: model.modelData.orbit_center || model.modelData.astrocoordinate.isValid

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
