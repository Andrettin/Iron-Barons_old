import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Window 2.13

Item {
	anchors.fill: parent
	Keys.forwardTo: key_handler

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

	function get_scroll_pixels() {
		if (key_handler.ctrlPressed) {
			return 25
		}

		return 5
	}

	WorldMap {
		id: map
	}

	Timer {
		running: scroll_left_area.containsMouse || scroll_left_up_area.containsMouse || scroll_left_down_area.containsMouse || key_handler.leftPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveLeft(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_right_area.containsMouse || scroll_right_up_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.rightPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveRight(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_up_area.containsMouse || scroll_left_up_area.containsMouse || scroll_right_up_area.containsMouse || key_handler.upPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveUp(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_down_area.containsMouse || scroll_left_down_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.downPressed
		repeat: true
		interval: 1
		onTriggered: {
			map.moveDown(get_scroll_pixels())
		}
	}

	Item {
		id: top_left_area
		anchors.top: parent.top
		anchors.left: parent.left
		width: 160
		height: 32

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
				text: metternich.game.player_character.titled_name
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
				text: "Wealth: " + centesimal(metternich.game.player_character.wealth)
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
				text: metternich.game.current_date_string
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
		visible: metternich.selected_province !== null
	}

	Button {
		id: settlement_holdings_button
		anchors.top: province_interface.top
		anchors.topMargin: province_interface.holding_area_y + 8
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null
		text: "<font color=\"black\">Settlements</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.holding_area_mode = ProvinceInterface.HoldingAreaMode.Settlements
		}
	}

	Button {
		id: palace_holdings_button
		anchors.top: settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && metternich.selected_province.palace_holding_slots.length > 0
		text: "<font color=\"black\">Palaces</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.holding_area_mode = ProvinceInterface.HoldingAreaMode.Palaces
		}
	}

	Button {
		id: extra_holdings_button
		anchors.top: palace_holdings_button.visible ? palace_holdings_button.bottom : settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null
		text: "<font color=\"black\">Other</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.holding_area_mode = ProvinceInterface.HoldingAreaMode.Other
		}
	}

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

	Item {
		id: key_handler
		focus: true
		property bool leftPressed: false
		property bool rightPressed: false
		property bool upPressed: false
		property bool downPressed: false
		property bool ctrlPressed: false

		Keys.onLeftPressed: leftPressed = true
		Keys.onRightPressed: rightPressed = true
		Keys.onUpPressed: upPressed = true
		Keys.onDownPressed: downPressed = true

		Keys.onPressed: {
			if (event.key === Qt.Key_Control) {
				ctrlPressed = true
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
			} else if (event.key === Qt.Key_Control) {
				ctrlPressed = false
			/*
			} else if (event.key === Qt.Key_Z) {
				map.zoomLevel += 0.5
			} else if (event.key === Qt.Key_X) {
				map.zoomLevel -= 0.5
			*/
			}
		}
	}

	Button {
		id: country_map_mode_button
		anchors.bottom: de_jure_empire_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Country</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Country
		}
	}

	Button {
		id: de_jure_empire_map_mode_button
		anchors.bottom: de_jure_kingdom_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">De Jure Empire</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureEmpire
		}
	}

	Button {
		id: de_jure_kingdom_map_mode_button
		anchors.bottom: de_jure_duchy_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">De Jure Kingdom</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureKingdom
		}
	}

	Button {
		id: de_jure_duchy_map_mode_button
		anchors.bottom: culture_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">De Jure Duchy</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureDuchy
		}
	}

	Button {
		id: culture_map_mode_button
		anchors.bottom: culture_group_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Culture</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Culture
		}
	}

	Button {
		id: culture_group_map_mode_button
		anchors.bottom: religion_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Culture Group</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.CultureGroup
		}
	}

	Button {
		id: religion_map_mode_button
		anchors.bottom: religion_group_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Religion</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Religion
		}
	}

	Button {
		id: religion_group_map_mode_button
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		text: "<font color=\"black\">Religion Group</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.ReligionGroup
		}
	}
}
