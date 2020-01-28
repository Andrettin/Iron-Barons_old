import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.14

Item {
	id: game_view

	property var current_world_map: null

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

	Rectangle {
		anchors.fill: parent
		color: "black"
	}

	DropArea {
		anchors.fill: parent
	}

	Repeater {
		model: metternich.worlds

		WorldMap {
			viewport: game_view
			world: model.modelData
			visible: metternich.current_world === world

			onVisibleChanged: {
				if (visible) {
					game_view.current_world_map = this
				}
			}

			Component.onCompleted: {
				if (metternich.current_world === world) {
					game_view.current_world_map = this
				}

				var center_coordinate
				var map_center

				if (metternich.game.player_character && metternich.game.player_character.primary_title.capital_province.world === world) {
					center_coordinate = metternich.game.player_character.primary_title.capital_province.center_coordinate;
					map_center = world.coordinate_to_point(center_coordinate)
					this.x = (game_view.parent.width / 2) - map_center.x
					this.y = (game_view.parent.height / 2) - map_center.y
				} else {
					this.x = (game_view.parent.width / 2) - (this.width / 2)
					this.y = (game_view.parent.height / 2) - (this.height / 2)
				}
			}
		}
	}

	Timer {
		running: scroll_left_area.containsMouse || scroll_left_up_area.containsMouse || scroll_left_down_area.containsMouse || key_handler.leftPressed
		repeat: true
		interval: 1
		onTriggered: {
			current_world_map.moveLeft(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_right_area.containsMouse || scroll_right_up_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.rightPressed
		repeat: true
		interval: 1
		onTriggered: {
			current_world_map.moveRight(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_up_area.containsMouse || scroll_left_up_area.containsMouse || scroll_right_up_area.containsMouse || key_handler.upPressed
		repeat: true
		interval: 1
		onTriggered: {
			current_world_map.moveUp(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_down_area.containsMouse || scroll_left_down_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.downPressed
		repeat: true
		interval: 1
		onTriggered: {
			current_world_map.moveDown(get_scroll_pixels())
		}
	}

	Item {
		id: top_left_area
		anchors.top: parent.top
		anchors.left: parent.left
		width: player_character_label.width + 8 + 8
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
				text: metternich.game.player_character ? metternich.game.player_character.titled_name : ""
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 8
				color: "black"
				font.pixelSize: 12
				font.family: "tahoma"
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (metternich.game.player_character !== null) {
						metternich.selected_character = metternich.game.player_character
					}
				}
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
			anchors.right: parent.right
			anchors.top: parent.top
			width: 64 + 8 + 8 + 8
			height: 32
			visible: metternich.game.player_character

			Image {
				anchors.verticalCenter: parent.verticalCenter
				anchors.left: parent.left
				anchors.leftMargin: 8

				source: "../graphics/icons/wealth.png"

				MouseArea {
					anchors.fill: parent
					hoverEnabled: true
					ToolTip.text: tooltip("Wealth")
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
				}
			}

			Text {
				id: wealth_label
				text: metternich.game.player_character ? centesimal(metternich.game.player_character.wealth) : ""
				anchors.verticalCenter: parent.verticalCenter
				anchors.right: parent.right
				anchors.rightMargin: 8
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
				anchors.rightMargin: 8
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
		visible: metternich.selected_province !== null && metternich.selected_character === null
		province: metternich.selected_province
	}

	CharacterInterface {
		id: character_interface
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		visible: metternich.selected_character !== null
		character: metternich.selected_character
	}

	Button {
		id: settlement_holdings_button
		anchors.top: province_interface.top
		anchors.topMargin: province_interface.holding_area_y + 8
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && metternich.selected_province.settlement_holding_slots.length > 0 && (metternich.selected_province.owner !== null || metternich.game.player_character !== null)
		text: "<font color=\"black\">Settlements</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.mode = ProvinceInterface.Mode.Settlements
		}
	}

	Button {
		id: palace_holdings_button
		anchors.top: settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && metternich.selected_province.palace_holding_slots.length > 0 && (metternich.selected_province.owner !== null || metternich.game.player_character !== null)
		text: "<font color=\"black\">Palaces</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.mode = ProvinceInterface.Mode.Palaces
		}
	}

	Button {
		id: extra_holdings_button
		anchors.top: palace_holdings_button.visible ? palace_holdings_button.bottom : settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && (metternich.selected_province.owner !== null || metternich.game.player_character !== null)
		text: "<font color=\"black\">Other</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.mode = ProvinceInterface.Mode.Other
		}
	}

	Button {
		id: technologies_button
		anchors.top: extra_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && (metternich.selected_province.owner !== null || metternich.game.player_character !== null)
		text: "<font color=\"black\">Technologies</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.mode = ProvinceInterface.Mode.Technologies
		}
	}

	Button {
		id: wildlife_button
		anchors.top: technologies_button.visible ? technologies_button.bottom : province_interface.top
		anchors.topMargin: technologies_button.visible ? 0 : (province_interface.holding_area_y + 8)
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && metternich.selected_province.wildlife_units.length > 0
		text: "<font color=\"black\">Wildlife</font>"
		width: 96
		height: 32
		font.pixelSize: 12
		onClicked: {
			province_interface.mode = ProvinceInterface.Mode.Wildlife
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
			} else if (event.key === Qt.Key_Escape) {
				if (metternich.selected_character !== null) {
					metternich.selected_character = null
				} else {
					if (metternich.selected_province !== null) {
						metternich.selected_province.selected = false
					}
					if (metternich.selected_holding !== null) {
						metternich.selected_holding.selected = false
					}
				}
			/*
			} else if (event.key === Qt.Key_Z) {
				current_world_map.zoomLevel += 0.5
			} else if (event.key === Qt.Key_X) {
				current_world_map.zoomLevel -= 0.5
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
		anchors.bottom: trade_node_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Religion Group</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.ReligionGroup
		}
	}

	Button {
		id: trade_node_map_mode_button
		anchors.bottom: trade_zone_map_mode_button.top
		anchors.right: parent.right
		text: "<font color=\"black\">Trade Node</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.TradeNode
		}
	}

	Button {
		id: trade_zone_map_mode_button
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		text: "<font color=\"black\">Trade Zone</font>"
		width: 128
		height: 32
		font.pixelSize: 12
		onClicked: {
			metternich.map_mode = WorldMap.Mode.TradeZone
		}
	}

	Grid {
		id: world_button_grid
		visible: metternich.worlds.length > 1
		anchors.bottom: parent.bottom
		anchors.right: country_map_mode_button.left
		columns: 1
		columnSpacing: 0
		rowSpacing: 0

		Repeater {
			model: metternich.worlds

			Button {
				text: "<font color=\"black\">" + model.modelData.name + "</font>"
				width: 128
				height: 32
				font.pixelSize: 12
				onClicked: {
					metternich.current_world = model.modelData
				}
			}
		}
	}
	
	Repeater {
		model: metternich.event_instances

		EventDialog {
			event_instance: model.modelData
			x: game_view.width / 2 - width / 2
			y: game_view.height / 2 - height / 2
		}
	}
	
	Component.onCompleted: {
		metternich.paused = false
	}
}
