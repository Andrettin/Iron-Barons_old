import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Window 2.14
import QtGraphicalEffects 1.12

Item {
	id: game_view

	property var current_world: metternich.game.player_character && metternich.game.player_character.capital_province ? metternich.game.player_character.capital_province.world : null
	property bool cosmic_map_enabled: current_world === null
	property var selected_world: null
	property var territory_interface: province_interface.visible ? province_interface : (world_interface.visible ? world_interface : null)

	anchors.fill: parent
	Keys.forwardTo: key_handler

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

	WorldMap {
		id: map_underlay
		world: current_world
		visible: current_world !== null

		Component.onCompleted: {
			var center_coordinate
			var map_center

			if (metternich.game.player_character && metternich.game.player_character.capital_province && metternich.game.player_character.capital_province.world === world) {
				center_coordinate = metternich.game.player_character.capital_province.center_coordinate;
				map_center = world.coordinate_to_point(center_coordinate)
				this.x = (game_view.width / 2) - map_center.x
				this.y = (game_view.height / 2) - map_center.y
			} else {
				this.x = (game_view.width / 2) - (this.width / 2)
				this.y = (game_view.height / 2) - (this.height / 2)
			}
		}
	}

	CosmicMap {
		id: cosmic_map
		visible: cosmic_map_enabled
	}

	MapView {
		id: map_view
		anchors.fill: game_view
		visible: cosmic_map_enabled

		importScene: cosmic_map_enabled ? cosmic_map : null
	}

	Timer {
		running: scroll_left_area.containsMouse || scroll_left_up_area.containsMouse || scroll_left_down_area.containsMouse || key_handler.leftPressed
		repeat: true
		interval: 1
		onTriggered: {
			map_underlay.move_left(get_scroll_pixels())
			map_view.move_left(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_right_area.containsMouse || scroll_right_up_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.rightPressed
		repeat: true
		interval: 1
		onTriggered: {
			map_underlay.move_right(get_scroll_pixels())
			map_view.move_right(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_up_area.containsMouse || scroll_left_up_area.containsMouse || scroll_right_up_area.containsMouse || key_handler.upPressed
		repeat: true
		interval: 1
		onTriggered: {
			map_underlay.move_up(get_scroll_pixels())
			map_view.move_up(get_scroll_pixels())
		}
	}

	Timer {
		running: scroll_down_area.containsMouse || scroll_left_down_area.containsMouse || scroll_right_down_area.containsMouse || key_handler.downPressed
		repeat: true
		interval: 1
		onTriggered: {
			map_underlay.move_down(get_scroll_pixels())
			map_view.move_down(get_scroll_pixels())
		}
	}

	Repeater {
		model: [settlement_holdings_button, palace_holdings_button, extra_holdings_button, technologies_button, wildlife_button, country_map_mode_button, de_jure_empire_map_mode_button, de_jure_kingdom_map_mode_button, de_jure_duchy_map_mode_button, culture_map_mode_button, culture_group_map_mode_button, religion_map_mode_button, religion_group_map_mode_button, trade_node_map_mode_button, trade_zone_map_mode_button ]
		
		DropShadow {
			anchors.fill: model.modelData
			source: model.modelData
			transparentBorder: true
			radius: 4.0
			samples: 9
			visible: model.modelData.visible
		}
	}
	
	Item {
		id: top_left_area
		anchors.top: parent.top
		anchors.left: parent.left
		width: player_character_label.width + 8 + 8
		height: 32

		PanelBackground {
			anchors.fill: parent
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
				hoverEnabled: true
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

		PanelBackground {
			anchors.fill: parent
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true //prevent mouse events from propagating below
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

	Item {
		id: notification_area
		anchors.top: top_bar.bottom
		anchors.topMargin: 16
		anchors.left: top_bar.left
		anchors.right: top_bar.right
		height: 64

		PanelBackground {
			anchors.fill: parent
		}

		MouseArea {
			anchors.fill: parent
			hoverEnabled: true //prevent mouse events from propagating below
		}

		Text {
			id: current_notification
			text: use_panel_highlight(metternich.current_notification)
			anchors.top: parent.top
			anchors.topMargin: 8
			anchors.left: parent.left
			anchors.leftMargin: 8
			anchors.right: parent.right
			anchors.rightMargin: 8
			anchors.bottom: parent.bottom
			anchors.bottomMargin: 8
			color: "black"
			font.pixelSize: 12
			font.family: "tahoma"
			wrapMode: Text.WordWrap
			clip: true
		}
	}

	WorldInterface {
		id: world_interface
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		visible: game_view.selected_world !== null && metternich.selected_character === null
		world: game_view.selected_world
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
	
	IconButton {
		id: settlement_holdings_button
		anchors.top: province_interface.top
		anchors.topMargin: province_interface.holding_area_y + 8
		anchors.left: province_interface.right
		visible: territory_interface && territory_interface.territory && metternich.selected_holding === null && territory_interface.territory.settlement_holding_slots.length > 0 && (territory_interface.territory.owner || metternich.game.player_character !== null)
		source: "../graphics/icons/settlement.png"
		ToolTip.text: tooltip("Settlements")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			territory_interface.mode = TerritoryInterface.Mode.Settlements
		}
	}

	IconButton {
		id: palace_holdings_button
		anchors.top: settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: territory_interface && territory_interface.territory && metternich.selected_holding === null && territory_interface.territory.palace_holding_slots.length > 0 && (territory_interface.territory.owner !== null || metternich.game.player_character !== null)
		source: "../graphics/icons/items/crown_baronial.png"
		ToolTip.text: tooltip("Palaces")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			territory_interface.mode = TerritoryInterface.Mode.Palaces
		}
	}

	IconButton {
		id: extra_holdings_button
		anchors.top: palace_holdings_button.visible ? palace_holdings_button.bottom : settlement_holdings_button.bottom
		anchors.left: province_interface.right
		visible: territory_interface && territory_interface.territory && metternich.selected_holding === null && (territory_interface.territory.owner !== null || metternich.game.player_character !== null)
		source: "../graphics/icons/buildings/wall.png"
		ToolTip.text: tooltip("Other")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			territory_interface.mode = TerritoryInterface.Mode.Other
		}
	}

	IconButton {
		id: technologies_button
		anchors.top: extra_holdings_button.bottom
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && (metternich.selected_province.owner !== null || metternich.game.player_character !== null)
		source: "../graphics/icons/research.png"
		ToolTip.text: tooltip("Technologies")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			province_interface.mode = TerritoryInterface.Mode.Technologies
		}
	}

	IconButton {
		id: wildlife_button
		anchors.top: technologies_button.visible ? technologies_button.bottom : province_interface.top
		anchors.topMargin: technologies_button.visible ? 0 : (province_interface.holding_area_y + 8)
		anchors.left: province_interface.right
		visible: province_interface.visible && metternich.selected_holding === null && metternich.selected_province.wildlife_units.length > 0
		source: "../graphics/icons/fauna/lion.png"
		ToolTip.text: tooltip("Wildlife")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			province_interface.mode = TerritoryInterface.Mode.Wildlife
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
			} else if (event.key === Qt.Key_Z) {
				map_underlay.zoom_in()
				map_view.zoom_in()
			} else if (event.key === Qt.Key_X) {
				map_underlay.zoom_out()
				map_view.zoom_out()
			}
		}
	}

	IconButton {
		id: country_map_mode_button
		anchors.bottom: de_jure_empire_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/flag.png"
		ToolTip.text: tooltip("Country")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Country
		}
	}

	IconButton {
		id: de_jure_empire_map_mode_button
		anchors.bottom: de_jure_kingdom_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/items/crown_imperial.png"
		ToolTip.text: tooltip("De Jure Empire")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureEmpire
		}
	}

	IconButton {
		id: de_jure_kingdom_map_mode_button
		anchors.bottom: de_jure_duchy_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/items/crown_royal.png"
		ToolTip.text: tooltip("De Jure Kingdom")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureKingdom
		}
	}

	IconButton {
		id: de_jure_duchy_map_mode_button
		anchors.bottom: culture_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/items/crown_ducal.png"
		ToolTip.text: tooltip("De Jure Duchy")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.DeJureDuchy
		}
	}

	IconButton {
		id: culture_map_mode_button
		anchors.bottom: culture_group_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/items/book.png"
		ToolTip.text: tooltip("Culture")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Culture
		}
	}

	IconButton {
		id: culture_group_map_mode_button
		anchors.bottom: religion_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/items/book.png"
		ToolTip.text: tooltip("Culture Group")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.CultureGroup
		}
	}

	IconButton {
		id: religion_map_mode_button
		anchors.bottom: religion_group_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/wooden_cross.png"
		ToolTip.text: tooltip("Religion")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.Religion
		}
	}

	IconButton {
		id: religion_group_map_mode_button
		anchors.bottom: trade_node_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/wooden_cross.png"
		ToolTip.text: tooltip("Religion Group")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.ReligionGroup
		}
	}

	IconButton {
		id: trade_node_map_mode_button
		anchors.bottom: trade_zone_map_mode_button.top
		anchors.right: parent.right
		source: "../graphics/icons/chest.png"
		ToolTip.text: tooltip("Trade Node")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.TradeNode
		}
	}

	IconButton {
		id: trade_zone_map_mode_button
		anchors.bottom: parent.bottom
		anchors.right: parent.right
		source: "../graphics/icons/chest.png"
		ToolTip.text: tooltip("Trade Zone")
		ToolTip.visible: hovered
		ToolTip.delay: 1000
		onClicked: {
			metternich.map_mode = WorldMap.Mode.TradeZone
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

	TargetedDecisionDialog {
		id: targeted_decision_dialog
	}

	function open_targeted_decision_dialog(target, target_ui_element) {
		targeted_decision_dialog.target = target
		targeted_decision_dialog.target_ui_element = target_ui_element
		targeted_decision_dialog.open()
	}

	Component.onCompleted: {
		metternich.paused = false
	}
}
