#import "preamble.typ": *
#show: template.with(footer: [Grundläggande elektroteknik, mikrokontroller & CircuitPython], handout: false)

#title-slide[
  = Rymdteknik --- Föreläsning 1
  Grundläggande elektroteknik, mikrokontroller & CircuitPython

  #v(1cm)

  _Marcell Ziegler_

  #text(size: 18pt, datetime.today().display())
]

== Struktur <touying:hidden>
#[
  #set text(size: 11pt)
  #components.adaptive-columns(outline(title: none))
]

= Vad är en mikrokontroller?

== Vad är en mikrokontroller?

#slide(composer: (auto, 1fr))[
  - Sammanfattat: liten dator.
    - Också känt som *MCU*: Micro Controller Unit.
  #pause
  - *Mikrokontroller* används bland annat för att:
    - Styra elektriska komponenter som:
      - Lampor
      - Motorer
      - Fjärkontroller
    - Läsa av sensorer som:
      - Barometrar
      - Accelerometrar
      - Termometrar
][
  #uncover("1-", figure(
    image("assets/image.png"),
    caption: [Ett RP2040 mikrokontrollerchipp.],
  ))
]

== Mikrokontroller på RFS
#slide()[
  - Vi använder *Adafruit Feather RP2040*.
    - Feather:n är ett *breakout board* för MCU:n
  #pause
  - Vi programmerar chippet i *CircuitPython*.
    - En mindre Pythontolk för MCU:er.
][
  #uncover("1-", figure(
    image("assets/image-2.png"),
    caption: [En Adafruit Feather RP2040.],
  ))
]

#speaker-note([
  - Nämn varför "breakout"
  - Peka på de olika delarna!
])

= Grundläggande ellära

#speaker-note([
  - Det första många tänker på är "kretsar"
  - Det andra är "elektricitet"
  - Du kommer lära dig inte paja din *Feather*!
])

== De elektriska storheterna
- Elektricitet mäts huvudsakligen i två storheter:
  - *Ström* ($I$) med enheten Ampere (A).
    - Ett flöde av laddningar.
    #pause
  - *Spänning* ($U$) med enheten Volt (V).
    - En potentialskillnad.
    #pause
    - *Potential* är "elektrisk lägesenergi".

== Elektricitet som vatten i rör

#slide[
  #set align(center)
  #show: move.with(dy: 1cm)
  #zap.circuit({
    import zap: *

    cetz.draw.scale(3)
    battery("b1", (0, 0), (0, 3), label: "Batteri")
    wire("b1.out", (rel: (2, 0)), name: "w1")
    resistor("r1", "w1.out", (rel: (0, -3)), label: "Resistor")
    wire("r1.out", "b1.in")
  })
][
  #pause
  #set align(center)
  #show: move.with(dy: 1.4cm)
  #cetz-canvas({
    import cetz.draw: *

    rect((-2, 3), (2, -3))
    scale(1.5)
    rect((-2, 2.8), (2, -2.8))
    scale(1)
    circle((-1.66, 0), radius: 1, fill: white, name: "pump")
    line("pump.south", "pump.north", mark: (end: (symbol: "stealth", fill: black, scale: 3)), stroke: 5pt)

    let angle = 20deg
    arc((-1.51, 0), radius: 3, start: -angle, delta: 2 * angle, anchor: "origin", fill: white)
    arc((4.84, 0), radius: 3, start: -angle - 180deg, delta: 2 * angle, anchor: "origin", fill: white, name: "res")

    content("res.east", [Motstånd], anchor: "west", padding: 10pt)
    content("pump.west", [Pump], anchor: "east", padding: 10pt)
  })
]

---

#[
  #set align(center)
  #show: move.with(dy: 1.4cm)
  #cetz-canvas({
    import cetz.draw: *

    rect((-2, 3), (2, -3))
    scale(1.5)
    rect((-2, 2.8), (2, -2.8))
    scale(1)
    circle((-1.66, 0), radius: 1, fill: white, name: "pump")
    line("pump.south", "pump.north", mark: (end: (symbol: "stealth", fill: black, scale: 3)), stroke: 5pt)

    let angle = 20deg
    arc((-1.51, 0), radius: 3, start: -angle, delta: 2 * angle, anchor: "origin", fill: white)
    arc((4.84, 0), radius: 3, start: -angle - 180deg, delta: 2 * angle, anchor: "origin", fill: white, name: "res")

    content("res.east", [Motstånd], anchor: "west", padding: 10pt)
    content("pump.west", [Pump], anchor: "east", padding: 10pt)

    (pause,)
    let height = 3
    line((-4.5, -height), (-4.5, height), mark: (end: (symbol: "stealth", fill: black)), stroke: 2pt, name: "up")
    content("up.mid", [Ökande potential\ $==>$ ökande spänning], anchor: "east", padding: 10pt)

    (pause,)
    line((4.5, height), (4.5, -height), mark: (end: (symbol: "stealth", fill: black)), stroke: 2pt, name: "down")

    content("down.mid", [Minskande potential\ $==>$ Fallande spännign], anchor: "west", padding: 10pt)
  })
]

#speaker-note([
  - Illustrera på tavlan hur olika kretsar alltid leder tillbaka till 0.
])

== Kirchhoff II -- Kirchoffs spänningslag

#[
  #set align(horizon)
  #quote[
    Summan av alla potentialändringar i en krets är alltid 0.
  ]
]

== De två typerna av Ström
- *Likström* (DC)
  - Elektricitet flödar åt samma håll.
- *Växelström* (AC)
  - Elektriciteten vänder håll periodiskt.

#speaker-note([
  - Vi behandlar endast DC.
])


== Kirchhoff I --- Kirchhoffs lag om strömdelning

#[
  #set align(horizon)
  #quote[
    Summan av alla strömmar in i en punkt är lika med summan av alla strömmar ut ur en punkt#footnote[Lagen lyder egentligen "Summan av alla strömmar som passerar en punkt är 0", men min formulering är likvärdig och mer intuitiv.]
  ]
]

---

#[
  #set align(center + horizon)
  #zap.circuit({
    import zap: *
    set-style(line: (stroke: 1.5pt))
    let len = 3
    node("n1", (0, 0), radius: .1)
    wire((-len, 0), (0, 0), i: $I_1$)
    wire((len, 0), (0, 0), i: (content: $I_3$, anchor: "south"))
    wire((0, 0), (0, len), i: (content: $I_2$, anchor: "east"))
    wire((0, 0), (0, -len), i: (content: $I_4$, anchor: "west"))
  })

  #pause
  Detta ger att $I_1 + I_3 = I_2 + I_2$ enligt Kirchhoff II.
]

= Enkla komponenter

== Resistorn

#slide(
  [
    - Skapar elektriskt motstånd.
    #pause
    - Har egenskapen *resistans*. ($Omega$, Ohm)
    #pause
    - "Förbrukar" spänning.
    - *Spänningsfallet* över resistorn följer *Ohms lag*:
      $ U = R I $
  ],
  [
    #set align(center + horizon)
    #uncover("1-")[
      #v(4cm)
      #figure(
        zap.circuit({
          import zap: *
          zap.cetz.draw.scale(3)
          resistor("r1", (0, 0), (rel: (3, 0)))
        }),
        caption: "En resistor",
      )
    ]
  ],
)

== Spänningskällan

#slide(
  composer: (60%, auto),
  [
    - Ökar potentialen med dess *polspänning*.
      - Alltså har den ett negativt spänningsfall.
    #pause
    - Polspänningen anges vid komponenten.
    #pause
    - Kan vara ett:
      - Batteri
      - Nätaggregat
      - Strömpin på MCU
  ],
  [
    #uncover("1-")[
      #show: move.with(dx: 4mm)
      #set text(size: 16pt)
      #figure(
        zap.circuit({
          import zap: *
          battery("b1", (0, 0), (rel: (3, 0)), variant: "ieee", label: (content: zi.V[12]))
        }),
        caption: "Ett batteri.",
      )
      #v(1cm)
      #figure(
        zap.circuit({
          import zap: *
          vsource("r1", (0, 0), (rel: (3, 0)), variant: "ieee", label: (content: zi.V[230]))
        }),
        caption: "En generell DC-källa.",
      )
      #v(1cm)
      #figure(
        zap.circuit({
          import zap: *
          zap.cetz.draw.scale(2)
          wire((-2, 0), (-1, 0))
          node("n1", (-1, 0), fill: false, label: (content: $-$, anchor: "east"))
          wire((1, 0), (2, 0))
          node("n1", (1, 0), fill: false, label: (content: $+$, anchor: "west"))
          draw.content((0, 0), $U$)
        }),
        caption: [En polspänning.\ Ibland en DC-källa, ibland en anvisning.],
      )
    ]
  ],
)

== Ledningar

#slide(
  [
    - Anses har ingen resistans.
    - Spänningsfallet är 0 V.
    - Kan också kallas:
      - Sladd
      - Kabel
  ],
  [
    #set align(center + horizon)
    #uncover("1-")[
      #v(5cm)
      #figure(
        zap.circuit({
          import zap: *
          zap.cetz.draw.scale(3)
          wire((0, 0), (rel: (3, 0)))
        }),
        caption: "En ledning.",
      )
    ]
  ],
)

== Lysdioder

#slide(
  [
    #set text(size: 18pt)
    - LED står för Light Emitting Diode
    #pause
    - Avger ljus av en viss färg.
    #pause
    - Leder bara ström åt ett håll
    #pause
    - Spänningen över en LED är konstant och beror på färg.
    #[
      #set text(size: 14pt)
      #set align(center)
      #table(
        columns: 2,
        table.header([*Färg*], [*Framåtspänning*]),
        [Röd], [1.5--#zi.V[2.0]],
        [Orange], [2.0--#zi.V[2.1]],
        [Gul], [2.1--#zi.V[2.2]],
        [Grön], [1.9--#zi.V[4.0]],
        [Blå], [2.5--#zi.V[3.7]],
      )
    ]
  ],
  [
    #set align(center + horizon)
    #uncover("1-")[
      #figure(
        zap.circuit({
          import zap: *
          set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
          zap.cetz.draw.scale(3)
          diode("d1", (0, 0), (rel: (3, 0)), type: "emitting")
        }),
        caption: "En LED.",
      )
    ]
  ],
)

= Enkla kretsar

== Lagen om spänningsdelning

#slide[
  #set text(size: 20pt)
  - Om man *seriekopplar* resistorer delas späniningen.
  - Strömmen förblir samma.
  #pause
  - Om vi vet resistanserna, vet vi att späninngarna blir enligt Kirchhoff II:
    $ U_1 = U dot R_1 / (R_1 + R_2) $
    och
    $ U_2 = U dot R_2 / (R_1 + R_2). $
][
  #set align(center)
  #uncover("1-", zap.circuit({
    import zap: *
    set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
    draw.scale(2)
    node("plus", (), fill: false)
    wire((), (2, 0), i: $I$, name: "w1")
    resistor("r1", "w1.out", (rel: (0, -2.5)), label: (content: $R_1$, anchor: "south"), u: $U_1$)
    resistor("r2", "r1.out", (rel: (0, -2.5)), label: (content: $R_2$, anchor: "south"), u: $U_2$)
    wire("r2.out", (rel: (-2, 0)), name: "w2")
    node("minus", "w2.out", fill: false)

    draw.content((0, -2.5), [$U$])
    draw.content((rel: (0, -.5), to: "plus.south"), $+$)
    draw.content((rel: (0, .5), to: "minus.north"), $-$)
  }))
]

#speaker-note([
  - Visa att $U = U_1 + U_2$ med Kirchhoff II!
])

== Spänningsdelaren
#slide[
  - För spänningsdelaren gäller
    $
      V_"ut" = U_"källa" - U_1,
    $
    vilket är samma sak som
    $
      V_"ut" = U_"källa" (1 - R_1 / (R_1 + R_2)).
    $
  #pause
  - Vi kan alltså dela spänningen olika med olika $R_1$.


][
  #set align(center)
  #uncover("1-", zap.circuit({
    import zap: *
    draw.scale(2)
    set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
    vsource("v1", (0, -5), (0, 0), variant: "ieee", label: $U_"källa"$)
    wire((), (2, 0), i: $I$, name: "w1")
    resistor("r1", "w1.out", (rel: (0, -2.5)), label: (content: $R_1$, anchor: "south"), u: $U_1$)
    resistor("r2", "r1.out", (rel: (0, -2.5)), label: (content: $R_2$, anchor: "south"), u: $U_2$)
    wire("r2.out", (rel: (-2, 0)), name: "w2")
    node("n1", "r1.out")
    wire("r1.out", (rel: (2, 0)), name: "w3")
    node("n2", "w3.out", fill: false, label: (content: $V_"ut"$))
  }))
]

== En tillämpning för spänningsdelaren
#let pins = (
  (content: "RESET", side: "west"),
  (content: "3.3V", side: "west"),
  (content: "3.3V", side: "west"),
  (content: "GND", side: "west"),
  (content: "A0", side: "west"),
  (content: "A1", side: "west"),
  (content: "A2", side: "west"),
  (content: "A3", side: "west"),
  (content: "D24", side: "west"),
  (content: "D25", side: "west"),
  (content: "SCK", side: "west"),
  (content: "MOSI", side: "west"),
  (content: "MISO", side: "west"),
  (content: "RX", side: "west"),
  (content: "TX", side: "west"),
  (content: "D4", side: "west"),
  (content: "VBAT", side: "east"),
  (content: "EN", side: "east"),
  (content: "VBUS", side: "east"),
  (content: "D13", side: "east"),
  (content: "D12", side: "east"),
  (content: "D11", side: "east"),
  (content: "D10", side: "east"),
  (content: "D9", side: "east"),
  (content: "D6", side: "east"),
  (content: "D5", side: "east"),
  (content: "SCL", side: "east"),
  (content: "SDA", side: "east"),
)

#[
  #set text(size: 16pt)
  #align(center + horizon, zap.circuit({
    import zap: *
    draw.scale(1.4)

    mcu("rp2040", (0, 0), pins: pins, label: "RP2040")
    wire("rp2040.pin2", (rel: (-3, 0)), name: "w1")
    resistor("r1", "w1.out", (rel: (0, -2)), label: (content: $R_1$, anchor: "south"), u: $U_1$)
    wire("r1.out", (rel: (0, -1)), name: "w2")
    swire("w2.center", (rel: (-2, -3)), name: "w3")
    node("n1", "w2.center")
    wire("w3.out", (rel: (3.5, 0)), name: "w4")
    zwire("w4.out", "rp2040.pin6")
    resistor("r2", "w2.out", (rel: (0, -2)), label: (content: $R_2$, anchor: "south"), u: $U_2$)
    zwire("r2.out", "rp2040.pin4")
  }))
]

== Lagen om strömförgrening

#slide[
  - Strömmen delar sig vid *parallelkopplig*.
  - Spänningen är samma över båda.
  #pause
  - Från Kirchhoff I får vi att
    $
      I_1 = I dot R_2 / (R_1 + R_2)
    $
    och
    $
      I_2 = I dot R_1 / (R_1 + R_2).
    $
][
  #set align(center)
  #uncover("1-", {
    v(.8cm)
    zap.circuit({
      import zap: *
      set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
      draw.scale(2)
      node("plus", (), fill: false)
      wire((), (rel: (2, 0)), name: "w1", i: $I$)
      resistor(
        "r1",
        "w1.out",
        (rel: (0, -3)),
        label: (content: $R_1$, anchor: "south"),
        u: $U_1$,
        i: (content: $I_1$, anchor: "south"),
      )
      wire("r1.in", (rel: (3, 0)), name: "w2")
      resistor(
        "r2",
        "w2.out",
        (rel: (0, -3)),
        label: (content: $R_2$, anchor: "south"),
        u: $U_2$,
        i: (content: $I_2$, anchor: "south"),
      )
      wire("r2.out", "r1.out", name: "w3")
      wire("r1.out", (rel: (-2, 0)), name: "w3", i: (content: $I$, anchor: "south"))
      node("minus", "w3.out", fill: false)
      node("n3", "r1.in")
      node("n3", "r1.out")
      draw.content((rel: (0, -.5), to: "plus.south"), $+$)
      draw.content((rel: (0, .5), to: "minus.north"), $-$)
      draw.content((0, -1.5), $U_"tot"$)
    })
  })
]

#speaker-note([
  - Visa att $I = I_1 + I_2$ enligt Kirchhoff I.
])

= Att reducera kretsar

== Ekvivalens med resistorer i serie

Seriekopplade resistorer:
#align(center)[
  #zap.circuit({
    import zap: *
    set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
    draw.scale(2)
    resistor("r1", (0, 0), (rel: (3, 0)), label: $R_1$)
    resistor("r1", (3, 0), (rel: (3, 0)), label: $R_2$)
    resistor("r1", (9, 0), (rel: (3, 0)), label: $R_n$)
    draw.content(((9 + 6) / 2, 0), $dots.c$)
  })
]
Har gemensam resistans:
$
  R_"tot" = R_1 + R_2 + dots.c + R_n = sum_(i = 1)^n R_i.
$

== Ekvivalens med parallella resistorer

parallellkopplade resistorer:
#align(center)[
  #v(-5mm)
  #zap.circuit({
    import zap: *
    set-style(stroke: 2pt, wire: (stroke: 1pt), decoration: (scale: 2))
    draw.scale(1.5)
    wire((0, 0), (rel: (6, 0)))
    resistor("r1", (1, 0), (rel: (0, -3)), label: $R_1$)
    resistor("r1", (3, 0), (rel: (0, -3)), label: $R_2$)
    resistor("r1", (6, 0), (rel: (0, -3)), label: $R_n$)
    draw.content((4.7, -1.5), $dots.c$)
    wire((0, -3), (rel: (6, 0)))
    node("n1", (0, 0), label: [A])
    node("n1", (0, -3), label: [B])
  })
]
Har gemensam resistans:
$
  1 / R_"tot" = 1 / R_1 + 1 / R_2 + dots.c + 1 / R_n quad <==> quad R_"tot" = (1 / R_1 + dots.c + 1 / R_n)^(-1) =( sum_(i = 1)^n 1 / R_i )^(-1)
$

== Reduktion till tvåpolsekvivalent

Samtliga *resistiva* kretsar kan reduceras till en *spänningsekvivalent*:


#align(center, zap.circuit({
  import zap: *
  draw.scale(1.5)
  set-style(wire: (stroke: 1.5pt), node: (scale: (x: 1.5, y: 1.5)))
  vsource("v1", (0, -2), (0, 2), variant: "ieee", label: $E$)
  resistor("r1", "v1.out", (rel: (3, 0)), label: $R_"ekv"$)
  node("plus", "r1.out", fill: false, label: (content: $+$, anchor: "south"))
  wire("v1.in", (rel: (3, 0)), name: "w2")
  node("minus", "w2.out", fill: false, label: (content: $-$, anchor: "north"))
  draw.content((3, 0), $U_"ekv"$)
}))

= Ett stort reduktionsexempel

== Ursprungskretsen

#align(center, zap.circuit({
  import zap: *
  vsource("v1", (-6, 0), (6, 0), variant: "ieee", label: zi.V[230])
  resistor("r1", "v1.out", (rel: (0, -5)), label: zi.ohm[320])
  wire("r1.out", (rel: (-3, 0)), name: "w1")
  node("n1", "w1.out")
  wire("n1", (rel: (0, 2)), name: "w2")
  resistor("r2", "w2.out", (rel: (-3, 0)), label: zi.ohm[1090])
  resistor("r3", "r2.out", (rel: (-3, 0)), label: zi.ohm[420])
  wire("n1", (rel: (0, -2)), name: "w3")
  resistor("r4", "w3.out", (rel: (-3, 0)), label: (content: zi.ohm[520], anchor: "south"))
  lamp("l1", "r4.out", (rel: (-3, 0)))
  wire("l1.out", (rel: (0, -.5)), name: "wb")
  wire("l1.in", (rel: (0, -.5)), name: "wa")
  node("b", "wb.out", label: (content: $B$, anchor: "south"))
  node("a", "wa.out", label: (content: $A$, anchor: "south"))
  wire("r3.out", (rel: (0, -2)))
  wire("l1.out", (rel: (0, 2)), name: "w5")
  node("n2", "w5.out")
  resistor("r5", "n2", (rel: (-3, 0)), label: zi.ohm[330])
  wire("r5.out", "v1.in")
}))

#speaker-note([
  - Vi klipper sen vid A och B!
  - Rita ekvivalenten!
])

== Kretsen uppvikt


#align(center, zap.circuit({
  import zap: *

  draw.scale(1.4)
  vsource("v1", (-3, 0), (3, 0), variant: "ieee", label: zi.V[230])
  resistor("r1", "v1.out", (rel: (0, -3)), label: zi.ohm[320])
  resistor("r2", "r1.out", (rel: (-3, 0)), label: zi.ohm[1090])
  resistor("r3", "r2.out", (rel: (-3, 0)), label: zi.ohm[420])
  resistor("r4", "r1.out", (rel: (0, -3)), label: zi.ohm[520])
  resistor("r5", "r3.out", (rel: (0, 3)), label: zi.ohm[320])
  wire("r3.out", (rel: (0, -3)), name: "w1")
  node("A", "r4.out", fill: false, label: (content: $A$, anchor: "south"))
  node("B", "w1.out", fill: false, label: (content: $B$, anchor: "south"))
}))
#speaker-note([
  - Beräkna polspänningen!
  - *BLÄDDRA FÖR SERIE RESISTOR!!*
])

== Polspänningen
#alternatives()[
  #align(center, zap.circuit({
    import zap: *

    draw.scale(1.4)
    vsource("v1", (-3, 0), (3, 0), variant: "ieee", label: zi.V[230])
    resistor("r1", "v1.out", (rel: (0, -3)), label: zi.ohm[320], i: $I$)
    resistor("r2", "r1.out", (rel: (-3, 0)), label: zi.ohm[1090])
    resistor("r3", "r2.out", (rel: (-3, 0)), label: zi.ohm[420], i: (content: $I$, anchor: "south"))
    resistor("r4", "r1.out", (rel: (0, -3)), label: zi.ohm[520], i: zi.ampere(0))
    resistor("r5", "r3.out", (rel: (0, 3)), label: zi.ohm[320], i: $I$)
    wire("r3.out", (rel: (0, -3)), name: "w1", i: zi.ampere(0))
    node("A", "r4.out", fill: false, label: (content: $A$, anchor: "south"))
    node("B", "w1.out", fill: false, label: (content: $B$, anchor: "south"))
    draw.content("A", $+$, anchor: "east", padding: 15pt)
    draw.content("B", $-$, anchor: "west", padding: 15pt)
    draw.content((0, -6), $U_(A B)$)
  }))
][
  #align(center, zap.circuit({
    import zap: *

    draw.scale(1.4)
    vsource("v1", (-3, 0), (3, 0), variant: "ieee", label: zi.V[230])
    resistor("r1", "v1.out", (rel: (0, -3)), label: zi.ohm[320], i: $I$)
    resistor("r2", "r1.out", (rel: (-6, 0)), label: zi.ohm[1510], i: (content: $I$, anchor: "south"))
    resistor("r4", "r1.out", (rel: (0, -3)), label: zi.ohm[520], i: zi.ampere(0))
    resistor("r5", "r2.out", (rel: (0, 3)), label: zi.ohm[320], i: $I$)
    wire("r2.out", (rel: (0, -3)), name: "w1", i: zi.ampere(0))
    node("A", "r4.out", fill: false, label: (content: $A$, anchor: "south"))
    node("B", "w1.out", fill: false, label: (content: $B$, anchor: "south"))
    draw.content("A", $+$, anchor: "east", padding: 15pt)
    draw.content("B", $-$, anchor: "west", padding: 15pt)
    draw.content((0, -6), $U_(A B)$)
  }))
]

#speaker-note[
  - Beräkna kortslutningsström / polspänning på tavlan.
  - Rita spänningsekvivalenten!

  + Summa serieresistorerna till $R_2$

  #set text(size: 16pt)
  $
    #grid(
      columns: 3,
      column-gutter: 25pt,
      row-gutter: 25pt,
      $U_"källa" = I_"öppen" (R_1 + R_2 + R_3) = zi.volt(230)$,
      $I_"öppen" = U_"källa" / (R_1 + R_2 + R_3) approx zi.ampere(0.106)$,

      $U_1 = R_1 I_"öppen" = zi.volt(33.92)$, $U_2 = R_2 I_"öppen" = zi.volt(160.06)$, $V_A = 230 - U_1 = 196.08$,
      $V_B = V_A - U_2 = zi.volt(36.02)$, $U_(A B) = V_A - V_B = 196.08 - 36.02 = zi.volt(160.06)$,
    )
  $
]

== Kortslutningsströmmen

#align(center, zap.circuit({
  import zap: *

  draw.scale(1.4)
  vsource("v1", (-3, 0), (3, 0), variant: "ieee", label: zi.V[230])
  resistor("r1", "v1.out", (rel: (0, -3)), label: zi.ohm[320], i: $I$)
  resistor("r2", "r1.out", (rel: (-6, 0)), label: zi.ohm[1510], i: (content: zi.ampere(0), anchor: "south"))
  resistor("r4", "r1.out", (rel: (0, -3)), label: zi.ohm[520])
  resistor("r5", "r2.out", (rel: (0, 3)), label: zi.ohm[320], i: $I$)
  wire("r2.out", (rel: (0, -3)), name: "w1")
  node("A", "r4.out", fill: false, label: (content: $A$, anchor: "south"))
  node("B", "w1.out", fill: false, label: (content: $B$, anchor: "south"))
  wire("A", "B", i: $I_(A B)$)
}))

#speaker-note([
  + Kortslutningsströmmen flödar $R_1,R_2,R_3$
    - $R_4$ vid $A$.

    #grid(
      columns: 2,
      column-gutter: 25pt,
      row-gutter: 35pt,
      $I_1 = I dot (R_2) / (R_1 + R_2) = I dot 0 / (0 + 1510) = 0$,
      $I_2 = I dot R_1 / (R_1 + R_2) = I dot (1510) / 1510 = I$,

      $I_(A B) = I, "enl. Kirchhoff I".$,
    )

    Resistorerna är i serie: $R = R_1 + R_4 + R_3 = zi.ohm(1162)$

    $
      U = R I_(A B) ==> zi.volt(230) / zi.ohm(1162) approx zi.ampere(0.198) = I_(A B)
    $
    som sen ger $E = R_"ekv" dot I_(A B) ==> R_"ekv" = E / I_(A B) = zi.volt(160.06) / zi.ampere(0.198) = zi.ohm(808.38)$
])

== Den ekvivalenta kretsen

#align(center + horizon, zap.circuit({
  import zap: *
  draw.scale(1.5)
  set-style(wire: (stroke: 1.5pt), node: (radius: .1), stroke: 1.5pt)
  vsource("v1", (0, -3), (0, 3), variant: "ieee", label: zi.volt(230))
  resistor("r1", "v1.out", (rel: (6, 0)), label: zi.ohm(808.38))
  node("n1", "r1.out", label: (content: $A$, anchor: "east"))
  lamp("l1", "r1.out", (rel: (0, -6)))
  node("n2", "l1.out", label: (content: $B$, anchor: "east"))
  wire("l1.out", "v1.in")
}))

= Rast! (15 min)

= Signaler

== Olika typer av signaler och sensorer

- *Digitala* signaler är sådana som är _på_ eller _av_. Detta är ex.:
  - Knappar (och alla strömbrytare)
  - Pulsgivare
  - *Integrerade kretsar*:
    - GPS-moduler
    - Accelerometrar
    - m.m.
#pause
- *Analoga* signaler är kontinuerliga i ett *referensintervall*. Detta är ex.:
  - Termistorer
  - Fotoresistorer
  - Potentiometrar
  - m.m.

= Att mäta signaler

== Digital avläsning

- Ett *högt* och ett *lågt* värde är definierat.
#pause
- Värden $>=$_hög_ är _på_.
- Värden $<=$_låg_ är _av_.
#pause
- Det är alltså binärt, och man kan:
  - Räkna pulser
  - Tolka knappar och strömbrytare
  - Kommunicera med digitala protokoll som I#super[2]C m.m.

#speaker-note([
  *Hög* resp. *låg* är ofta ett litet intervall!
])

== Analog avläsning

- Egentligen en spänningsmätare.
#pause
- Värdet varierar inom *referensintervallet*.
#pause
- Spänningen kan ofta konverteras till en storhet.

#line(length: 100%, stroke: au-blå + 2pt)
Exempel:
En termistor har egenskapen att
$
  R_"th" = f(T), quad f(T) = zi.ohm(100) + (degC(20) - T)
$
Innebär att resistansen ökar med #zi.ohm(20) för varje #degC(1) vilket vi kan mäta med en spänningsdelare!
