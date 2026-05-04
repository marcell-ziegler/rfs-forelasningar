#set page(height: auto, width: auto, margin: 5pt, fill: rgb("#00205b"))
#set text(fill: white)
#import "@preview/cetz:0.5.0"

#cetz.canvas({
  import cetz.draw: *
  let r = 2
  set-style(stroke: (paint: white))
  scale(r)
  (polygon((), 3, angle: 90deg, name: "tri"))
  scale(.5)
  arc((radius: r, angle: -180deg + 30deg), start: 0deg, delta: 60deg, radius: .3, anchor: "origin", name: "a")
  arc((radius: r, angle: 90deg), start: -90deg - 30deg, delta: 60deg, radius: .3, anchor: "origin", name: "b")
  arc((radius: r, angle: -30deg), start: 180deg, delta: -60deg, radius: .3, anchor: "origin", name: "c")

  content("a.start", anchor: "south-west", padding: .1, [$theta_1$])
  content("b.mid", anchor: "north", padding: .1, [$theta_2$])
  content("c.start", anchor: "south-east", padding: .1, [$theta_3$])
})
