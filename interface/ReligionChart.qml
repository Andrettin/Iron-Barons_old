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

		var population_per_religion = chart.dataSource.get_population_per_religion_qvariant_list()
		for (var i = 0; i < population_per_religion.length; i++) {
			var religion = population_per_religion[i].religion
			var population = population_per_religion[i].population
			var pie_slice = pie_series.append(religion.name, population)
			pie_slice.color = religion.color
			pie_slice.borderColor = "black"
		}
	}
}
