import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import MaskedMouseArea 1.0

Window {
	visible: true
	width: 640
	height: 480
	title: qsTr("Iron Barons")
	flags: Qt.FramelessWindowHint
	visibility: "Maximized"
	Item {
		id: map
		focus: true
		x: -3596
		y: -584

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

			Repeater {
				model: Metternich.provinces
				Image {
					x: model.modelData.rect.x
					y: model.modelData.rect.y
					width: model.modelData.rect.width
					height: model.modelData.rect.height
					source: "image://provinces/" + model.modelData.identifier
					Connections {
						target: model.modelData
						onImageChanged: parent.sourceChanged()
					}

					MaskedMouseArea {
						anchors.fill: parent
						alphaThreshold: 0.4
						maskSource: parent.source
						ToolTip.text: qsTr(model.modelData.identifier)
						ToolTip.visible: containsMouse
						ToolTip.delay: 1000
					}
				}
			}
		}
	}

}
