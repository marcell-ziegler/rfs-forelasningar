#import "@preview/touying:0.7.3": *
#import themes.simple: *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": *
#import "@preview/cetz:0.5.2"
#import "@preview/lovelace:0.3.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: circle, diamond, pill, rect
#import "@preview/zero:0.6.1": num

// cetz and fletcher bindings
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

#let pseudocode-list = pseudocode-list.with(hooks: .5em, line-gap: .7em)

#let au-blå = rgb("#00205b")

#let template(footer: [], handout: false, doc) = {
  show figure.caption: set text(size: 12pt, fill: luma(50%))
  show link: it => text(fill: blue, underline(it))

  show: codly-init.with()
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
  show raw.where(lang: "stdout"): it => {
    codly(number-format: none)
    it
    codly(number-format: numbering.with("1"))
  }


  set table(
    inset: 10pt,
    stroke: (x, y) => {
      if y == 1 {
        (top: 2pt + black)
      } else if y > 1 {
        (top: 1pt + black)
      }

      if x > 0 {
        (left: 1pt + black)
      }
    },
  )
  show table.header: strong

  set list(marker: ([#move(scale(text(fill: au-blå, sym.star.op), 150%), dy: -.15em)], [‣], [--]))

  show: simple-theme.with(
    aspect-ratio: "16-9",
    footer: footer,
    config-colors(
      primary: au-blå,
      secondary: rgb("#ffc600"),
    ),
    config-common(
      preamble: {
        codly(
          languages: (
            py: (name: "Python", color: blue.lighten(30%)),
            cpp: (name: "C++", color: blue),
            yasm: (name: "x86_64 Assembly", color: gray),
            gcc_ir: (name: "GCC Intermeidate Representation", color: gray),
            stdout: (name: "stdout", color: gray),
          ),
          fill: luma(98%),
          stroke: none,
        )
      },
      handout: handout,
    ),
  )

  set text(size: 22pt, lang: "sv")
  [#doc]
}
