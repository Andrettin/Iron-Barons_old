import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick3D 1.14

View3D {
	id: map_view

	function move_left(pixels) {
		var x = camera.position.x - pixels
		if (x < camera.min_x) {
			x = camera.min_x
		}
		camera.position.x = x
	}

	function move_right(pixels) {
		var x = camera.position.x + pixels
		if (x > camera.max_x) {
			x = camera.max_x
		}
		camera.position.x = x
	}

	function move_up(pixels) {
		var y = camera.position.y + pixels
		if (y > camera.max_y) {
			y = camera.max_y
		}
		camera.position.y = y
	}

	function move_down(pixels) {
		var y = camera.position.y - pixels
		if (y < camera.min_y) {
			y = camera.min_y
		}
		camera.position.y = y
	}

	function zoom_in() {
	}

	function zoom_out() {
	}

	function get_mouse_pos_astrocoordinate_x() {
		return Math.round(camera.mapFromViewport(Qt.vector3d(mouse_area.mouseX / map_view.width, mouse_area.mouseY / map_view.height, 0)).x)
	}

	function get_mouse_pos_astrocoordinate_y() {
		return Math.round(camera.mapFromViewport(Qt.vector3d(mouse_area.mouseX / map_view.width, mouse_area.mouseY / map_view.height, 0)).y) * -1
	}

	function get_tooltip_x() {
		return mouse_area.mouseX
	}

	function get_tooltip_y() {
		return mouse_area.mouseY
	}

	function get_view_pos(scene_pos) {
		var viewport_pos = camera.mapToViewport(scene_pos)
		return Qt.point(viewport_pos.x * map_view.width, viewport_pos.y * map_view.height)
	}

	environment: SceneEnvironment {
		backgroundMode: SceneEnvironment.Transparent
		multisampleAAMode: SceneEnvironment.X4
	}

	OrthographicCamera {
		id: camera

		property real min_x: metternich.cosmic_map_bounding_rect.left + (map_view.width / 2)
		property real max_x: metternich.cosmic_map_bounding_rect.right - (map_view.width / 2)
		property real min_y: (metternich.cosmic_map_bounding_rect.bottom * -1) + (map_view.height / 2)
		property real max_y: (metternich.cosmic_map_bounding_rect.top * -1) - (map_view.height / 2)

		position: Qt.vector3d(0, 0, Math.max(map_view.width, map_view.height) * -1)
		rotation: Qt.vector3d(0, 0, 0)
		frustumCullingEnabled: true

		onPositionChanged: {
			mouse_area.on_mouse_pos_changed(mouse_area.mouseX, mouse_area.mouseY)
		}
	}

	DirectionalLight {
		position: Qt.vector3d(0, 0, -1000)
		rotation: Qt.vector3d(0, 0, 0)
	}

	MouseArea {
		id: mouse_area
		property var hovered_object: null

		function on_mouse_pos_changed(mouse_x, mouse_y) {
			var result = map_view.pick(mouse_x, mouse_y)
			var hit_object = result.objectHit

			tooltip_timer.restart() //restart the tooltip delay (always restart when moving the mouse)

			if (hit_object !== null && !hit_object.is_valid_tooltip_pos(result.uvPosition)) {
				hit_object = null
			}

			if (hit_object !== tooltip_timer.delayed_hovered_object) {
				tooltip_timer.delayed_hovered_object = hit_object;
			}
		}

		function on_clicked(mouse) {
			var result = map_view.pick(mouse.x, mouse.y)
			var hit_object = result.objectHit

			tooltip_timer.restart() //clicking always restarts the tooltip delay

			if (hit_object !== null) {
				hit_object.click()
			} else {
				game_view.selected_world = null
			}
		}

		anchors.fill: map_view
		hoverEnabled: true
		onPositionChanged: {
			on_mouse_pos_changed(mouse.x, mouse.y)
		}
		onClicked: {
			if (metternich.selected_province !== null) {
				metternich.selected_province.selected = false
			}
			if (metternich.selected_holding !== null) {
				metternich.selected_holding.selected = false
			}
			metternich.selected_character = null

			on_clicked(mouse)
		}

		Timer {
			property var delayed_hovered_object: null

			id: tooltip_timer
			interval: 1000
			onTriggered: {
				mouse_area.hovered_object = delayed_hovered_object
			}
		}

		CustomToolTip {
			id: custom_tooltip
			text: tooltip(mouse_area.hovered_object ? mouse_area.hovered_object.tooltip_text
				: "Astrocoordinate: ("
				+ get_mouse_pos_astrocoordinate_x() + ", "
				+ get_mouse_pos_astrocoordinate_y() + ")")
			visible: mouse_area.containsMouse && !tooltip_timer.running
			delay: 0
			x: (mouse_area.hovered_object ? mouse_area.hovered_object.get_tooltip_x() : get_tooltip_x()) - (width / 2)
			y: (mouse_area.hovered_object ? mouse_area.hovered_object.get_tooltip_y() : get_tooltip_y()) - height - 8
		}
	}
}
