import QtQuick 2.14
import QtQuick3D 1.14

Model {
	property var world: null
	property int tooltip_update_counter: 0
	property string tooltip_text: world ? (world.name + "<br>"
	+ (world.star_system ? "<br>Star System: " + world.star_system.name : "")
	+ "<br>Type: " + world.type.name
	+ (world.county && metternich.map_mode === WorldMap.Mode.Country && world.county.realm ? "<br>Realm: " + world.county.realm.titled_name : "")
	+ (world.de_jure_empire && metternich.map_mode === WorldMap.Mode.DeJureEmpire ? "<br>De Jure Empire: " + world.de_jure_empire.name : "")
	+ (world.de_jure_kingdom && metternich.map_mode === WorldMap.Mode.DeJureKingdom ? "<br>De Jure Kingdom: " + world.de_jure_kingdom.name : "")
	+ (world.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture: " + world.culture.name : "")
	+ (world.culture && (metternich.map_mode === WorldMap.Mode.Culture || metternich.map_mode === WorldMap.Mode.CultureGroup) ? "<br>Culture Group: " + world.culture.group.name : "")
	+ (world.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion: " + world.religion.name : "")
	+ (world.religion && (metternich.map_mode === WorldMap.Mode.Religion || metternich.map_mode === WorldMap.Mode.ReligionGroup) ? "<br>Religion Group: " + world.religion.group.name : "")
	+ "<br>Astrocoordinate: (" + Math.round(world.cosmic_map_pos.x) + ", " + Math.round(world.cosmic_map_pos.y) + ")") : ""

	function get_tooltip_x() {
		return map_view.get_view_pos(position).x
	}

	function get_tooltip_y() {
		return map_view.get_view_pos(position).y - (world.cosmic_size / 2)
	}

	function is_valid_tooltip_pos(pos) {
		return true
	}

	function click() {
		if (world.selectable) {
			game_view.selected_world = world
		} else {
			game_view.selected_world = null
		}
	}

	function get_color(world_type) {
		if (world_type === "blue_giant_star" || world_type === "blue_dwarf_star") {
			return "blue"
		} else if (world_type === "class_a_giant_star" || world_type === "class_a_dwarf_star" || world_type === "blue_white_giant_star" || world_type === "blue_white_dwarf_star") {
			return "lightblue"
		} else if (world_type === "orange_giant_star" || world_type === "orange_dwarf_star") {
			return "orange"
		} else if (world_type === "red_giant_star" || world_type === "red_dwarf_star") {
			return "orange"
		} else if (world_type === "yellow_giant_star" || world_type === "yellow_dwarf_star") {
			return "yellow"
		} else if (world_type === "yellow_white_giant_star" || world_type === "yellow_white_dwarf_star") {
			return "lightyellow"
		}

		return "white"
	}

	//place moons above planets, and planets above stars, so that smaller bodies will have priority for the mouse when e.g. displaying a tooltip
	position: world ? Qt.vector3d(world.cosmic_map_pos.x, world.cosmic_map_pos.y * -1, world.moon ? -200 : (world.planet ? -100 : 0)) : Qt.vector3d(0, 0, 0)
	//the pixel size of the sphere model is by default c. 100x100
	scale: world ? Qt.vector3d(world.cosmic_size / 100.0, world.cosmic_size / 100.0, world.cosmic_size / 100.0) : Qt.vector3d(1, 1, 1)
	rotation: Qt.vector3d(-45, world ? world.rotation : 0, 0)
	source: "#Sphere"
	pickable: true
	visible: world && (world.orbit_center || world.astrocoordinate.isValid)

	materials: [
		DefaultMaterial {
			diffuseColor: world ? get_color(world.type.identifier) : "white"
			diffuseMap: world && world.star ? null : world_texture
		}
	]

	Texture {
		id: world_texture
		source: world ? world.texture_path : ""
	}
}
