import QtQuick 2.14
import QtQuick.Controls 2.5
import QtCharts 2.3

PopulationChart {
	id: chart

	function update_chart() {
		pie_series.clear()

		if (chart.dataSource === null) {
			return
		}

		var population_per_culture = chart.dataSource.get_population_per_culture_qvariant_list()
		for (var i = 0; i < population_per_culture.length; i++) {
			var culture = population_per_culture[i].culture
			var population = population_per_culture[i].population
			var pie_slice = pie_series.append(culture.name, population)
			pie_slice.color = culture.color
			pie_slice.borderColor = "black"
		}
	}
}
