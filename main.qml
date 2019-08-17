import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

Window {
	visible: true
	width: 640
	height: 480
	title: qsTr("Iron Barons")
	flags: Qt.FramelessWindowHint
	visibility: "Maximized"
	//visibility: "FullScreen"

	//function to format tooltip text
	function tooltip(text) {
		return "<font color=\"white\">" + text + "</font>"
	}

	//function to format numbers with two decimal places
	function centesimal(number) {
		var src_number_string = ""
		src_number_string += number
		var dest_number_string = ""
		if (number < 100) {
			dest_number_string += "0."
		} else {
			dest_number_string += src_number_string.slice(0, src_number_string.length - 2) + "."
		}
		if (number < 10) {
			dest_number_string += "0"
		}
		dest_number_string += src_number_string.slice(src_number_string.length - 2)
		return dest_number_string
	}

	Item {
		//set the shared properties for tooltips
		ToolTip.toolTip.palette.text: "white"
		ToolTip.toolTip.font.pixelSize: 14
		ToolTip.toolTip.font.family: "tahoma"
		ToolTip.toolTip.background: Rectangle {
			color: "black"
			opacity: 0.90
			border.color: "gray"
			border.width: 1
			radius: 5
		}
	}

	Item {
		id: key_handler
		focus: true
		property bool leftPressed: false
		property bool rightPressed: false
		property bool upPressed: false
		property bool downPressed: false

		Keys.onLeftPressed: leftPressed = true
		Keys.onRightPressed: rightPressed = true
		Keys.onUpPressed: upPressed = true
		Keys.onDownPressed: downPressed = true

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

		Keys.onReleased: {
			if (event.key === Qt.Key_Left) {
				leftPressed = false
			} else if (event.key === Qt.Key_Right) {
				rightPressed = false
			} else if (event.key === Qt.Key_Up) {
				upPressed = false
			} else if (event.key === Qt.Key_Down) {
				downPressed = false
			}
		}
	}

	Map {
		id: map
		x: -3596
		y: -584
	}

	Timer {
		running: scroll_left_area.containsMouse || scroll_left_up_area.containsMouse || scroll_left_down_area.containsMouse || key_handler.leftPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveLeft(1)
		}
	}

	Timer {
		running: scroll_right_area.containsMouse || scroll_right_up_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.rightPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveRight(1)
		}
	}

	Timer {
		running: scroll_up_area.containsMouse || scroll_left_up_area.containsMouse || scroll_right_up_area.containsMouse || key_handler.upPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveUp(1)
		}
	}

	Timer {
		running: scroll_down_area.containsMouse || scroll_left_down_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.downPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveDown(1)
		}
	}

	Item {
		id: top_left_area
		anchors.top: parent.top
		anchors.left: parent.left
		width: 128
		height: 64

		Rectangle {
			anchors.fill: parent
			color: "darkGray"
		}

		Item {
			id: player_character_area
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			height: 32

			Text {
				id: player_character_label
				text: Metternich.game.player_character.full_name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 8
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}

		Item {
			id: primary_title_area
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: player_character_area.bottom
			height: 32

			Text {
				id: primary_title_label
				text: Metternich.game.player_character.primary_title.name
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 8
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}
	}

	Item {
		id: top_bar
		anchors.top: parent.top
		anchors.right: parent.right
		width: 160
		height: 64

		Rectangle {
			anchors.fill: parent
			color: "darkGray"
		}

		Item {
			id: wealth_area
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.top: parent.top
			height: 32

			Text {
				id: wealth_label
				text: "Wealth: " + centesimal(Metternich.game.player_character.wealth)
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 32
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}

		Item {
			id: date_area
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			height: 32

			Text {
				id: date
				text: Metternich.game.current_date_string
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: 28
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}
		}
	}

	ProvinceInterface {
		id: province_interface
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		visible: Metternich.selected_province !== null
	}

	/*
	Item {
		id: holding_building
		width: 320
		height: 35

		Text {
			id: building_name
			text: "University"
			x: 35
			height: 32
			verticalAlignment: Text.AlignVCenter
			color: "white"
			font.pointSize: 12
			font.family: "tahoma"
		}
	}
	*/

	MouseArea {
		id: scroll_left_area
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.topMargin: 1
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 1
		width: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_right_area
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.topMargin: 1
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 1
		width: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_up_area
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.leftMargin: 1
		anchors.right: parent.right
		anchors.rightMargin: 1
		height: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_down_area
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.leftMargin: 1
		anchors.right: parent.right
		anchors.rightMargin: 1
		height: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_left_up_area
		anchors.left: parent.left
		anchors.top: parent.top
		width: 1
		height: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_left_down_area
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		width: 1
		height: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_right_up_area
		anchors.right: parent.right
		anchors.top: parent.top
		width: 1
		height: 1
		hoverEnabled: true
	}

	MouseArea {
		id: scroll_right_down_area
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		width: 1
		height: 1
		hoverEnabled: true
	}
}
