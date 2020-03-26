import QtQuick 2.14
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

Item {
	readonly property string holding_frame_base_image_path: "../graphics/interface/holding_frame_base_silver.png"
	readonly property string holding_frame_border_image_path: "../graphics/interface/holding_frame_border_silver.png"
	readonly property string holding_frame_middle_image_path: "../graphics/interface/holding_frame_middle_silver.png"
	readonly property int base_part_width: 1
	readonly property int base_part_height: 17
	readonly property int base_part_count: (holding_frame.width - (border_part_width * 2)) / base_part_width
	readonly property int base_part_right: holding_frame.width - base_part_height
	readonly property int base_part_bottom: holding_frame.height - base_part_height
	readonly property int border_part_width: 33
	readonly property int border_part_height: 17
	readonly property int border_part_right: holding_frame.width - border_part_height
	readonly property int border_part_bottom: holding_frame.height - border_part_height
	readonly property int middle_part_width: 13
	readonly property int middle_part_height: 17
	readonly property int middle_part_right: holding_frame.width - middle_part_height
	readonly property int middle_part_bottom: holding_frame.height - middle_part_height
	readonly property bool middle_part_visible: holding_frame.width >= (128 + 32)

	id: holding_frame

	function is_in_middle_part_area(n) {
		return n >= ((holding_frame.width / 2) - middle_part_width) && n < ((holding_frame.width / 2) + middle_part_width)
	}

	Image {
		source: holding_frame_border_image_path
		x: 0
		y: 0
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 90
		x: border_part_right - 8
		y: 0 + 8
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 180
		x: holding_frame.width - border_part_width
		y: border_part_bottom
	}

	Image {
		source: holding_frame_border_image_path
		rotation: 270
		x: 0 - 8
		y: holding_frame.height - border_part_width + 8
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		x: holding_frame.width - border_part_width
		y: 0
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 90
		x: border_part_right - 8
		y: holding_frame.height - border_part_width + 8
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 180
		x: 0
		y: border_part_bottom
	}

	Image {
		source: holding_frame_border_image_path
		mirror: true
		rotation: 270
		x: 0 - 8
		y: 0 + 8
	}

	Image {
		source: holding_frame_middle_image_path
		x: (holding_frame.width / 2) - middle_part_width
		y: 0
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		rotation: 90
		x: middle_part_right + 2
		y: (holding_frame.height / 2) - middle_part_width - 2
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		rotation: 180
		x: (holding_frame.width / 2)
		y: middle_part_bottom
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		rotation: 270
		x: 0 + 2
		y: (holding_frame.height / 2) - 2
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		mirror: true
		x: (holding_frame.width / 2)
		y: 0
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		mirror: true
		rotation: 90
		x: middle_part_right + 2
		y: (holding_frame.height / 2) - 2
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		mirror: true
		rotation: 180
		x: (holding_frame.width / 2) - middle_part_width
		y: middle_part_bottom
		visible: middle_part_visible
	}

	Image {
		source: holding_frame_middle_image_path
		mirror: true
		rotation: 270
		x: 0 + 2
		y: (holding_frame.height / 2) - middle_part_width - 2
		visible: middle_part_visible
	}

	Repeater {
		model: base_part_count

		Image {
			source: holding_frame_base_image_path
			x: border_part_width + (index * base_part_width)
			y: 0
			visible: !middle_part_visible || !is_in_middle_part_area(x)
		}
	}

	Repeater {
		model: base_part_count

		Image {
			source: holding_frame_base_image_path
			x: base_part_right + 8
			y: border_part_width + (index * base_part_width) - 8
			rotation: 90
			visible: !middle_part_visible || !is_in_middle_part_area(y + 8)
		}
	}

	Repeater {
		model: base_part_count

		Image {
			source: holding_frame_base_image_path
			rotation: 180
			x: border_part_width + (index * base_part_width)
			y: base_part_bottom
			visible: !middle_part_visible || !is_in_middle_part_area(x)
		}
	}

	Repeater {
		model: base_part_count

		Image {
			source: holding_frame_base_image_path
			rotation: 270
			x: 0 + 8
			y: border_part_width + (index * base_part_width) - 8
			visible: !middle_part_visible || !is_in_middle_part_area(y + 8)
		}
	}

	layer.enabled: true
	layer.effect: DropShadow {
		transparentBorder: true
		radius: 4.0
		samples: 9
		horizontalOffset: 1
		verticalOffset: 1
	}
}
