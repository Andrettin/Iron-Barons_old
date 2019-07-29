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
						ToolTip.text: qsTr(model.modelData.county.identifier)
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

	Item {
		id: top_bar
		anchors.top: parent.top
		anchors.right: parent.right
		width: 178 + 43 + 162
		height: 72

		Image {
			id: top_bar_background_right
			anchors.top: parent.top
			anchors.right: parent.right
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_right.dds"
		}

		Image {
			id: top_bar_background_middle
			anchors.top: parent.top
			anchors.right: top_bar_background_right.left
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_extension.dds"
		}

		Image {
			id: top_bar_background_left
			anchors.top: parent.top
			anchors.right: top_bar_background_middle.left
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_right_bg_left.dds"
		}

		Item {
			id: date_area
			anchors.top: parent.top
			anchors.topMargin: 40
			anchors.left: parent.left
			anchors.leftMargin: 71
			width: 259
			height: 24

			Image {
				id: date_background
				anchors.top: parent.top
				anchors.left: parent.left
				source: "file:///" + Metternich.asset_import_path + "/gfx/interface/topbar_date_pause_medium.dds"
			}

			Text {
				id: date
				text: Metternich.game.current_date_string
				anchors.top: parent.top
				anchors.topMargin: 4
				anchors.left: parent.left
				anchors.leftMargin: 7 + 3
				color: "white"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}
	}

	Item {
		id: province_interface
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		width: 348
		height: 624
		visible: Metternich.selected_province !== null

		Image {
			id: province_background
			source: "file:///" + Metternich.asset_import_path + "/gfx/interface/province_bg.dds"
		}

		Text {
			id: province_name
			text: Metternich.selected_province ? qsTr(Metternich.selected_province.county.identifier) : ""
			anchors.top: parent.top
			anchors.topMargin: 15
			anchors.left: parent.left
			anchors.leftMargin: 81
			color: "white"
			font.pixelSize: 14
			font.family: "tahoma"
		}

		Item {
			id: kingdom_area
			x: 17
			y: 267
			width: 153
			height: 32

			Text {
				id: province_de_jure_kingdom
				text: qsTr("Germany")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 31
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}

		Item {
			id: duchy_area
			x: 17
			y: 300
			width: 153
			height: 32

			Text {
				id: province_de_jure_duchy
				text: qsTr("Austria")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 31
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}

		Item {
			id: culture_area
			x: 17
			y: 333
			width: 153
			height: 13

			Text {
				id: culture_label
				text: qsTr("Culture")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 4
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}

			Text {
				id: province_culture
				text: qsTr("German")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.right: parent.right
				anchors.rightMargin: 5
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}

		Item {
			id: religion_area
			x: 17
			y: 347
			width: 153
			height: 13

			Text {
				id: religion_label
				text: qsTr("Religion")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 4
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}

			Text {
				id: province_religion
				text: qsTr("Catholic")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.right: parent.right
				anchors.rightMargin: 5
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}

		Item {
			id: supply_area
			x: 17
			y: 361
			width: 153
			height: 13

			Text {
				id: supply_label
				text: qsTr("Supply")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 4
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}

			Text {
				id: province_supply
				text: "10.0K"
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.right: parent.right
				anchors.rightMargin: 5
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}

		Item {
			id: revolt_risk_area
			x: 17
			y: 375
			width: 153
			height: 13

			Text {
				id: revolt_risk_label
				text: qsTr("Revolt Risk")
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.left: parent.left
				anchors.leftMargin: 4
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}

			Text {
				id: province_revolt_risk
				text: "0.0%"
				anchors.verticalCenter: parent.verticalCenter
				anchors.verticalCenterOffset: -2
				anchors.right: parent.right
				anchors.rightMargin: 5
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
				font.bold: true
			}
		}
	}
}
