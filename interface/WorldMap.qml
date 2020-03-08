import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Shapes 1.14
import MaskedMouseArea 1.0

Item {
	id: map

	property var world: null

	width: world ? world.map_size.width : 0
	height: world ? world.map_size.height : 0

	enum Mode {
		None,
		Country,
		DeJureEmpire,
		DeJureKingdom,
		DeJureDuchy,
		Culture,
		CultureGroup,
		Religion,
		ReligionGroup,
		TradeNode,
		TradeZone
	}

	function move_left(pixels) {
		map.x += pixels * map.scale
	}

	function move_right(pixels) {
		map.x -= pixels * map.scale
	}

	function move_up(pixels) {
		map.y += pixels * map.scale
	}

	function move_down(pixels) {
		map.y -= pixels * map.scale
	}

	function zoom_in() {
	}

	function zoom_out() {
	}
	
	Rectangle {
		id: map_background
		anchors.fill: parent
		color: "black"
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			if (metternich.selected_province !== null) {
				metternich.selected_province.selected = false
			}
			if (metternich.selected_holding !== null) {
				metternich.selected_holding.selected = false
			}
			metternich.selected_character = null
		}
	}

	Repeater {
		model: world ? world.provinces : []

		Shape {
			property var province: model.modelData
			property string tooltip_text: tooltip(
				province.name
				+ (province.county && metternich.map_mode === WorldMap.Mode.Country && province.county.realm ? "<br><br>Country: " + province.county.realm.titled_name : "")
				+ (province.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br><br>De Jure Empire: " + province.de_jure_empire.name : "")
				+ (province.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br><br>De Jure Kingdom: " + province.de_jure_kingdom.name : "")
				+ (province.de_jure_duchy && metternich.map_mode === WorldMap.Mode.DeJureDuchy ? "<br><br>De Jure Duchy: " + province.de_jure_duchy.name : "")
				+ (province.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br><br>Culture: " + province.culture.name : "")
				+ (province.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + province.culture.culture_group.name : "")
				+ (province.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br><br>Religion: " + province.religion.name : "")
				+ (province.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + province.religion.religion_group.name : "")
				+ (metternich.map_mode === WorldMap.Mode.TradeNode && province.trade_node && province.owner ? "<br><br>Trade Node: " + province.trade_node.name : "")
				+ (metternich.map_mode === WorldMap.Mode.TradeNode && province.trade_node && province.trade_node.center_of_trade === province && province.owner ? "<br>Center of Trade" : "")
				+ (metternich.map_mode === WorldMap.Mode.TradeNode && province.trade_node_trade_cost > 0 ? "<br>Trade Cost with Node: " + centesimal(province.trade_node_trade_cost) + "%" : "")
				+ (metternich.map_mode === WorldMap.Mode.TradeZone && province.trading_post_holding_slot && province.trading_post_holding_slot.holding ? "<br><br>Trade Zone: " + province.trading_post_holding_slot.holding.owner.primary_title.realm.name : "")
			)

			x: province.rect.x
			y: province.rect.y
			z: province.selected ? 1 : 0
			width: province.rect.width
			height: province.rect.height
			containsMode: Shape.FillContains

			ShapePath {
				strokeWidth: 2
				strokeColor: province.selected ? "yellow" : "black"
				strokeStyle: ShapePath.SolidLine
				fillColor: province.map_mode_color
				PathSvg { path: province.polygons_svg }
			}

			MouseArea {
				anchors.fill: parent
				hoverEnabled: true
				ToolTip.text: parent.tooltip_text
				ToolTip.visible: containsMouse
				ToolTip.delay: 1000
				containmentMask: parent
				onClicked: {
					if (metternich.selected_holding) {
						metternich.selected_holding.selected = false
					}
					if (province.selectable) {
						province.selected = true
					} else if (metternich.selected_province) {
						metternich.selected_province.selected = false
					}
					metternich.selected_character = null
				}
			}
		}
	}

	Repeater {
		model: world ? world.trade_routes : []

		Shape {
			property var trade_route: model.modelData

			visible: trade_route.active && metternich.map_mode === WorldMap.Mode.TradeNode
			x: trade_route.rect.x
			y: trade_route.rect.y
			z: 2
			width: trade_route.rect.width
			height: trade_route.rect.height

			ShapePath {
				strokeWidth: 2
				strokeColor: "gold"
				strokeStyle: ShapePath.SolidLine
				capStyle: ShapePath.RoundCap
				joinStyle: ShapePath.RoundJoin
				fillColor: "transparent"
				PathSvg { path: trade_route.path_branch_points_svg }
			}
		}
	}
}
