_width = display.contentWidth
_height = display.contentHeight
_centerX = display.contentCenterX
_centerY = display.contentCenterY
background = display.newRect(
  _centerX,
  _centerY,
  _width,
  _height + 100
)

local composer = require( "composer" )
composer.gotoScene("title")
