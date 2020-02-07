import QtQuick 2.12
import QtQuick.Controls 2.5

Popup {
	id: targeted_decision_dialog
	contentWidth: 192 + 16
	contentHeight: decision_grid.y + decision_grid.height + 8
	padding: 0
	x: target_ui_element ? (mapFromItem(target_ui_element, target_ui_element.x, target_ui_element.y).x + target_ui_element.width + 8) : 0
	y: target_ui_element ? mapFromItem(target_ui_element, target_ui_element.x, target_ui_element.y).y : 0
	visible: target !== null && target_ui_element !== null
	
	property var target: null
	property var target_ui_element: null

	onClosed: {
		target = null
		target_ui_element = null
	}

	background: PanelBackground {
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		//prevent events from propagating below
	}

	Text {
		id: target_name
		text: target ? target.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Grid {
		id: decision_grid
		anchors.top: target_name.bottom
		anchors.topMargin: 32
		anchors.horizontalCenter: parent.horizontalCenter
		columns: 1
		columnSpacing: 0
		rowSpacing: 4

		Repeater {
			model: target ? metternich.game.player_character.get_targeted_decisions(target) : []

			Item {
				width: children[0].width
				height: children[0].height

				property string tooltip_text: model.modelData.get_string(target, metternich.game.player_character)
					+ (model.modelData.description !== (model.modelData.identifier + "_desc") ? "<br><br>" + model.modelData.description : "")

				PanelButton {
					width: 192
					height: 32
					text: "<font color=\"black\">" + model.modelData.name + "</font>"
					ToolTip.text: tooltip(tooltip_text)
					ToolTip.visible: hovered
					ToolTip.delay: 1000
					enabled: model.modelData.check_conditions(target, metternich.game.player_character)
					onClicked: {
						model.modelData.do_effects(target, metternich.game.player_character)
						targeted_decision_dialog.close()
					}
				}

				MouseArea {
					anchors.fill: parent
					enabled: !parent.children[0].enabled
					hoverEnabled: enabled
					ToolTip.text: tooltip(tooltip_text)
					ToolTip.visible: containsMouse
					ToolTip.delay: 1000
				}
			}
		}
	}
}
