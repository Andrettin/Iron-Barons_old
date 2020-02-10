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
		return Qt.point(astrocoordinate.longitude * astrodistance / 180 * 4, astrocoordinate.latitude * astrodistance / 90 * 4)
	}

	function orbit_position_to_offset(orbit_position, distance_from_system_center) {
		return Qt.point(orbit_position.x * distance_from_system_center, orbit_position.y * distance_from_system_center)
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

		Repeater { //orbits
			model: metternich.worlds
			
			Rectangle {
				property point system_astrocoordinate: model.modelData.star_system ? astrocoordinate_to_pos(model.modelData.star_system.astrocoordinate, model.modelData.star_system.astrodistance) : Qt.point(0, 0)

				x: system_astrocoordinate.x + (cosmic_map.width / 2) - (width / 2)
				y: system_astrocoordinate.y + (cosmic_map.height / 2) - (height / 2)
				width: model.modelData.distance_from_system_center * 2
				height: model.modelData.distance_from_system_center * 2
				color: "transparent"
				border.color: "blue"
				border.width: 1
				radius: width * 0.5
			}
		}

		Repeater { //the worlds themselves
			model: metternich.worlds

			Rectangle { //the world itself
				property point system_astrocoordinate: model.modelData.star_system ? astrocoordinate_to_pos(model.modelData.star_system.astrocoordinate, model.modelData.star_system.astrodistance) : Qt.point(0, 0)
				property point system_offset: orbit_position_to_offset(model.modelData.orbit_position, model.modelData.distance_from_system_center)

				x: system_astrocoordinate.x + system_offset.x + (cosmic_map.width / 2) - (width / 2)
				y: system_astrocoordinate.y + system_offset.y + (cosmic_map.height / 2) - (height / 2)
				width: model.modelData.cosmic_pixel_size
				height: model.modelData.cosmic_pixel_size
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
