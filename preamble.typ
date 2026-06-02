#import "@preview/touying:0.7.3": *
#import themes.simple: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/cetz:0.5.2"
#import "@preview/lovelace:0.3.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: circle, diamond, rect
#import "@preview/zero:0.6.1": num

// cetz and fletcher bindings
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#let pseudocode-list = pseudocode-list.with(hooks: .5em, line-gap: .7em)

#let au-blå = rgb("#00205b")

#let template(footer: [], doc) = {
  show figure.caption: set text(size: 12pt, fill: luma(50%))
  show link: it => text(fill: blue, underline(it))

  show: codly-init.with()
  show raw: set text(
    font: "FiraCode Nerd Font Mono",
  )
  show raw.where(block: false): it => {
    set text(fill: purple.darken(30%))
    box(
      fill: luma(94%),
      inset: (x: 3pt, y: 0pt),
      outset: (y: 5pt),
      radius: 2pt,
      it,
    )
  }
  set table(inset: 10pt)

  show: simple-theme.with(
    aspect-ratio: "16-9",
    footer: footer,
    config-colors(
      primary: au-blå,
      secondary: rgb("#ffc600"),
    ),
    config-common(preamble: {
      codly(
        languages: (
          py: (name: "Python", color: blue.lighten(30%)),
          cpp: (name: "C++", color: blue),
          yasm: (name: "x86_64 Assembly", color: gray),
          gcc_ir: (name: "GCC Intermeidate Representation", color: gray),
        ),
        zebra-fill: none,
        fill: luma(96%),
        stroke: none,
      )
    }),
  )

  set text(size: 22pt, lang: "sv")
  [#doc]
}
