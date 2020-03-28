import QtQuick 2.14
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

Image {
	source: width >= 160 ? "../graphics/interface/holding_frame_large_silver.png" : "../graphics/interface/holding_frame_silver.png"

	layer.enabled: true
	layer.effect: DropShadow {
		transparentBorder: true
		radius: 4.0
		samples: 9
		horizontalOffset: 1
		verticalOffset: 1
		cached: true
	}
}
