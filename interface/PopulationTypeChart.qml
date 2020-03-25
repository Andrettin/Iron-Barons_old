import QtQuick 2.14
import QtQuick.Controls 2.5
import QtCharts 2.3
import QtGraphicalEffects 1.12

PopulationChart {
	id: chart

	function update_chart() {
		pie_series.clear()

		if (chart.dataSource === null) {
			return
		}

		var population_per_type = chart.dataSource.get_population_per_type_qvariant_list()
		for (var i = 0; i < population_per_type.length; i++) {
			var type = population_per_type[i].type
			var population = population_per_type[i].population
			var pie_slice = pie_series.append(type.name, population)
			pie_slice.color = type.color
			pie_slice.borderColor = "black"
		}
	}
}
