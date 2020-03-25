import QtQuick 2.14
import QtQuick.Controls 2.5
import QtCharts 2.3
import QtGraphicalEffects 1.12

ChartView {
	property var dataSource: null //the data source for the chart, e.g. a province or a holding
	readonly property var pie_series: pie_series

	id: chart
	width: 64
	height: 64
	margins.top: 0
	margins.bottom: 0
	margins.left: 0
	margins.right: 0
	legend.visible: false
	backgroundColor: "transparent"
	antialiasing: true
	ToolTip.delay: 1000

	onDataSourceChanged: chart.update_chart()

	PieSeries {
		id: pie_series
		size: 0.95

		onHovered: {
			if (state == true) {
				chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
				chart.ToolTip.visible = true
			} else {
				chart.ToolTip.visible = false
			}
		}
	}

	Connections {
		target: chart.dataSource
		ignoreUnknownSignals: true //as there may be no selected holding
		onPopulation_groups_changed: chart.update_chart()
	}

	layer.enabled: true
	layer.effect: DropShadow {
		transparentBorder: true
		radius: 4.0
		samples: 9
		verticalOffset: 1
		horizontalOffset: 1
	}
}
