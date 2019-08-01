import QtQuick 2.12
import QtQuick.Controls 2.5
import MaskedMouseArea 1.0

Item {
	id: map
	focus: true

	Keys.onLeftPressed: {
		map.x += 10 * map.scale
	}

	Keys.onRightPressed: {
		map.x -= 10 * map.scale
	}

	Keys.onUpPressed: {
		map.y += 10 * map.scale
	}

	Keys.onDownPressed: {
		map.y -= 10 * map.scale
	}

	Keys.onPressed: {
		if (event.key === Qt.Key_Z) {
			map.scale *= 2
			map.x *= 2
			map.y *= 2
		} else if (event.key === Qt.Key_X) {
			if (map.scale > 1) {
				map.scale /= 2
				map.x /= 2
				map.y /= 2
			}
		}
	}

	Image {
		id: map_terrain
		source: "./map/terrain.png"

		MouseArea {
			anchors.fill: parent
			onClicked: {
				if (Metternich.selected_province) {
					Metternich.selected_province.selected = false
				}
			}
		}

		Repeater {
			model: Metternich.provinces
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
					ToolTip.text: model.modelData.name
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
					onClicked: {
						model.modelData.selected = true
					}
				}
			}
		}
	}
}