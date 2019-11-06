import QtQuick 2.12
import QtQuick.Controls 2.5

Flickable {
	property variant holding_model: []

	id: holding_flickable
	contentWidth: holding_grid.width
	contentHeight: holding_grid.height
	clip: true
	interactive: false
	boundsBehavior: Flickable.StopAtBounds
	ScrollBar.vertical: ScrollBar {}

	Grid {
		id: holding_grid
		columns: 3
		columnSpacing: 1
		rowSpacing: 1

		Repeater {
			model: holding_flickable.holding_model

			Holding {
				visible: model.modelData !== metternich.selected_province.capital_holding.slot
				holding_slot: model.modelData
			}
		}
	}
}
