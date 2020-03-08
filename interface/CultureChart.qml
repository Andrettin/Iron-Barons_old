import QtQuick 2.14
import QtQuick.Controls 2.5
import QtCharts 2.3

ChartView {
	property var dataSource: null //the data source for the chart, e.g. a province or a holding

	id: culture_chart
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

	onDataSourceChanged: culture_chart.update_chart()

	PieSeries {
		id: culture_pie_series
		size: 0.95

		onHovered: {
			if (state == true) {
				culture_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
				culture_chart.ToolTip.visible = true
			} else {
				culture_chart.ToolTip.visible = false
			}
		}
	}

	function update_chart() {
		culture_pie_series.clear()

		if (culture_chart.dataSource === null) {
			return
		}

		var population_per_culture = culture_chart.dataSource.get_population_per_culture_qvariant_list()
		for (var i = 0; i < population_per_culture.length; i++) {
			var culture = population_per_culture[i].culture
			var population = population_per_culture[i].population
			var pie_slice = culture_pie_series.append(culture.name, population)
			pie_slice.color = culture.color
			pie_slice.borderColor = "black"
		}
	}

	Connections {
		target: culture_chart.dataSource
		ignoreUnknownSignals: true //as there may be no selected holding
		onPopulation_groups_changed: culture_chart.update_chart()
	}
}
