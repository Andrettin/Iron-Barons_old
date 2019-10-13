import QtQuick 2.12
import QtQuick.Controls 2.5

MouseArea {
	property var province: null
	property bool contained_in_shape: false

	hoverEnabled: true
	ToolTip.text: tooltip(province.name + (province.county ? "<br><br>Country: " + province.county.realm.titled_name : ""))
	ToolTip.visible: containsMouse
	ToolTip.delay: 1000

	onClicked: {
		if (metternich.selected_holding) {
			metternich.selected_holding.selected = false
		}
		if (province.selectable) {
			province.selected = true
		} else if (metternich.selected_province) {
			metternich.selected_province.selected = false
		}
	}
}
