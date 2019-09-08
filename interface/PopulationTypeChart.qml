import QtQuick 2.12
import QtQuick.Controls 2.5
import QtCharts 2.3

ChartView {
	property var dataSource: null //the data source for the chart, e.g. a province or a holding

	id: population_type_chart
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

	onDataSourceChanged: population_type_chart.update_chart()

	PieSeries {
		id: population_type_pie_series
		size: 0.95

		onHovered: {
			if (state == true) {
				population_type_chart.ToolTip.text = "<font color=\"white\">" + slice.label + " (" + (slice.percentage * 100).toFixed(2) + "%)</font>"
				population_type_chart.ToolTip.visible = true
			} else {
				population_type_chart.ToolTip.visible = false
			}
		}
	}

	function update_chart() {
		population_type_pie_series.clear()

		if (population_type_chart.dataSource === null) {
			return
		}

		var population_per_type = population_type_chart.dataSource.get_population_per_type_qvariant_list()
		for (var i = 0; i < population_per_type.length; i++) {
			var type = population_per_type[i].type
			var population = population_per_type[i].population
			var pie_slice = population_type_pie_series.append(type.name, population)
			pie_slice.color = type.color
			pie_slice.borderColor = "black"
		}
	}

	Connections {
		target: population_type_chart.dataSource
		ignoreUnknownSignals: true //as there may be no selected holding
		onPopulation_groups_changed: population_type_chart.update_chart()
	}
}
