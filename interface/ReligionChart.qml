import QtQuick 2.14
import QtQuick.Controls 2.5
import QtCharts 2.3

ChartView {
	property var dataSource: null //the data source for the chart, e.g. a province or a holding

	id: religion_chart
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

	onDataSourceChanged: religion_chart.update_chart()

	PieSeries {
		id: religion_pie_series
		size: 0.95

		onHovered: {
			if (state == true) {
				religion_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
				religion_chart.ToolTip.visible = true
			} else {
				religion_chart.ToolTip.visible = false
			}
		}
	}

	function update_chart() {
		religion_pie_series.clear()

		if (religion_chart.dataSource === null) {
			return
		}

		var population_per_religion = religion_chart.dataSource.get_population_per_religion_qvariant_list()
		for (var i = 0; i < population_per_religion.length; i++) {
			var religion = population_per_religion[i].religion
			var population = population_per_religion[i].population
			var pie_slice = religion_pie_series.append(religion.name, population)
			pie_slice.color = religion.color
			pie_slice.borderColor = "black"
		}
	}

	Connections {
		target: religion_chart.dataSource
		ignoreUnknownSignals: true //as there may be no selected holding
		onPopulation_groups_changed: religion_chart.update_chart()
	}
}
