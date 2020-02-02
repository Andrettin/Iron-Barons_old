import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: event_dialog
	width: 320
	height: event_option_grid.y + event_option_grid.height + 8
	
	property var event_instance: null

	PanelBackground {
		anchors.fill: parent
	}

	Drag.active: drag_area.drag.active

	MouseArea {
		id: drag_area
		anchors.fill: parent
		hoverEnabled: true
		drag.target: parent
	}

	Text {
		id: event_name
		text: event_instance ? event_instance.name : ""
		anchors.top: parent.top
		anchors.topMargin: 16
		anchors.horizontalCenter: parent.horizontalCenter
		color: "black"
		font.pixelSize: 14
		font.family: "tahoma"
		font.bold: true
	}

	Text {
		id: event_description
		text: event_instance ? event_instance.description : ""
		anchors.top: event_name.bottom
		anchors.topMargin: 32
		anchors.left: parent.left
		anchors.leftMargin: 8
		anchors.right: parent.right
		anchors.rightMargin: 8
		color: "black"
		font.pixelSize: 12
		font.family: "tahoma"
		wrapMode: Text.WordWrap
	}

	Grid {
		id: event_option_grid
		anchors.top: event_description.bottom
		anchors.topMargin: 32
		anchors.horizontalCenter: parent.horizontalCenter
		columns: 1
		columnSpacing: 0
		rowSpacing: 4

		Repeater {
			model: event_instance ? event_instance.options : []

			PanelButton {
				width: 192
				height: 32
				text: "<font color=\"black\">" + model.modelData.name + "</font>"
				ToolTip.text: tooltip(model.modelData.effects_string)
				ToolTip.visible: hovered
				ToolTip.delay: 1000
				onClicked: {
					model.modelData.do_effects()
					game_view.forceActiveFocus()
					metternich.remove_event_instance(event_instance)
				}
			}
		}
	}
}
