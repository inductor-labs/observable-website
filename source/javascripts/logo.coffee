{cos, sin} = Math
{rad} = Raphael

toPointOnArc = (center, radius, angle) ->
  radians = rad(angle)
  x = center[0] + cos(radians) * radius
  y = center[1] + sin(radians) * radius

  [x, y]

Arc = (center, radius, startAngle, endAngle) ->
  angle = startAngle
  path = ""

  while angle <= endAngle
    if angle is startAngle
      command = "M"
    else
      command = " L"

    [x, y] = toPointOnArc(center, radius, angle)
    path += "#{command} #{x} #{y}"
    angle += 1

    path

size = 50

paper = Raphael("logo", size, size)

radius = 15
center = [size / 2, size / 2]

arc = Arc(center, radius, 0, 360)

paper.path(arc).attr
  stroke: "#000"
  "stroke-width": radius * 0.8

angles = (x for x in [0..360] by 45)

angles.forEach (angle) ->
  arc = Arc(center, radius, angle - 10, angle + 10)

  wedge = paper.path(arc).attr
    stroke: "white"
    "stroke-width": radius

  wedge.mouseover ->
    wedge.stop().animate {stroke: "#18BC9C"}, 200

  wedge.mouseout ->
    wedge.stop().animate {stroke: "white"}, 200
