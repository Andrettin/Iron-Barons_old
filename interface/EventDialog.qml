import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
	id: event_dialog
	width: 320
	height: 480
	
	property var event_instance: null

	Rectangle {
		id: background
		anchors.fill: parent
		color: "darkGray"
	}

	Drag.active: drag_area.drag.active
	Drag.hotSpot.x: 10
	Drag.hotSpot.y: 10

	MouseArea {
		id: drag_area
		anchors.fill: parent
		hoverEnabled: true
		drag.target: parent
	}

	Grid {
		id: event_option_grid
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 8
		anchors.horizontalCenter: parent.horizontalCenter
		columns: 1
		columnSpacing: 0
		rowSpacing: 4

		Repeater {
			model: event_instance ? event_instance.options : []

			Button {
				width: 128
				height: 32
				text: "<font color=\"black\">" + model.modelData.name + "</font>"
				font.pixelSize: 12
				font.family: "tahoma"
				onClicked: {
					model.modelData.do_effects()
					metternich.remove_event_instance(event_instance)
				}
			}
		}
	}
}
