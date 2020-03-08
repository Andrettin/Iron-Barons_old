import QtQuick 2.14
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12

Rectangle {
	color: "darkGray"
	radius: 5

	layer.enabled: true
	layer.effect: DropShadow {
		transparentBorder: true
		radius: 4.0
		samples: 9
	}
}
