import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: map

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
					ToolTip.text: tooltip(model.modelData.name + (model.modelData.county ? "<br><br>Country: " + model.modelData.county.realm.titled_name : ""))
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