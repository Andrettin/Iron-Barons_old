import QtQuick 2.12
import QtQuick.Controls 2.14

ToolTip {
	id: tooltip
	font.family: "tahoma"
	font.pixelSize: 14
	contentWidth: (tooltip_metrics.width + 2)
	background: Rectangle {
		color: "black"
		opacity: 0.90
		border.color: "gray"
		border.width: 1
		radius: 5
	}
	onTextChanged: tooltip_metrics.text = get_longest_line(remove_text_colors(tooltip.text), 64)

	TextMetrics {
		id: tooltip_metrics
		font.family: "tahoma"
		font.pixelSize: 14
	}
}
