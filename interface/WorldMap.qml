import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: map

	enum Mode {
		Country,
		Culture,
		CultureGroup,
		Religion
	}

	function moveLeft(pixels) {
		map.x += pixels * map.scale
	}

	function moveRight(pixels) {
		map.x -= pixels * map.scale
	}

	function moveUp(pixels) {
		map.y += pixels * map.scale
	}

	function moveDown(pixels) {
		map.y -= pixels * map.scale
	}

	Component.onCompleted: {
		var center_coordinate = metternich.game.player_character.primary_title.capital_province.center_coordinate;
		var map_center = metternich.coordinate_to_point(center_coordinate)
		map.x = parent.width / 2 - map_center.x
		map.y = parent.height / 2 - map_center.y
	}

	Image {
		id: map_terrain
		source: "../map/provinces.png"

		MouseArea {
			anchors.fill: parent
			onClicked: {
				if (metternich.selected_province) {
					metternich.selected_province.selected = false
				}
				if (metternich.selected_holding) {
					metternich.selected_holding.selected = false
				}
			}
		}

		Repeater {
			model: metternich.provinces
			Image {
				x: model.modelData.rect.x
				y: model.modelData.rect.y
				width: model.modelData.rect.width
				height: model.modelData.rect.height
				source: "image://provinces/" + model.modelData.identifier
				cache: false

				Connections {
					target: model.modelData
					onImageChanged: {
						var old_source = source
						source = "image://empty/"
						source = old_source
					}
				}

				MaskedMouseArea {
					anchors.fill: parent
					alphaThreshold: 0.4
					maskSource: parent.source
					ToolTip.text: tooltip(
						model.modelData.name
						+ (model.modelData.county ? "<br>" : "")
						+ (model.modelData.county && metternich.map_mode === WorldMap.Mode.Country ? "<br>Country: " + model.modelData.county.realm.titled_name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture: " + model.modelData.culture.name : "")
						+ (model.modelData.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + model.modelData.culture.culture_group.name : "")
						+ (model.modelData.religion && metternich.map_mode === WorldMap.Mode.Religion ? "<br>Religion: " + model.modelData.religion.name : "")
					)
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
					}
				}
			}
		}
	}
}
