#import "preamble.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"
#show: template.with(footer: [Funktioner & upprepningsbar kod])

#title-slide[
  = Programmering --- Föreläsning 2
  Funktioner & upprepningsbar kod

  #v(1cm)

  _Marcell Ziegler_

  #text(size: 18pt, datetime.today().display())
]

= Funktioner

== Funktionsbegreppet

Vad är en funktion?

- En funktion är lite som en mekanisk låda:
  #pause
  1. Något kan gå in.
  #pause
  2. Det behandlas.
  #pause
  3. Och något kan gå ut.

== Matematiska funktioner

Ett matematiskt uttryck som tar *argument* och ger ett *funktionsvärde*.






#columns(2)[
  #set align(center)
  En graf av $f(x) = 5x + 3$
  #{
    let x = lq.linspace(-10, 10, num: 1000)
    show: lq.set-tick(inset: 5pt, outset: 5pt)
    show lq.selector(lq.tick-label): set text(.6em)
    let filter(val, dist) = val != 0 and dist >= 10pt
    lq.diagram(
      width: 80%,
      height: 7cm,
      xaxis: (position: 0, tip: tiptoe.stealth, filter: filter),
      yaxis: (position: 0, tip: tiptoe.stealth, filter: filter),
      lq.plot(x, x => 5 * x + 3, mark: none, stroke: 1.5pt),
    )
  }
  #colbreak()
  En graf av $g(x) = 5x^2 - 2x + 3$
  #{
    let x = lq.linspace(-5, 5.45, num: 1000)
    show: lq.set-tick(inset: 5pt, outset: 5pt)
    show lq.selector(lq.tick-label): set text(.6em)
    let filter(val, dist) = val != 0 and dist >= 10pt
    lq.diagram(
      width: 80%,
      height: 7cm,
      xaxis: (position: 0, tip: tiptoe.stealth, filter: filter),
      yaxis: (position: 0, tip: tiptoe.stealth, filter: filter),
      lq.plot(x, x => 5 * x * x - 2 * x + 3, mark: none, stroke: 1.5pt),
    )
  }
]

== Funktioner som en låda

Betrakta funktionen som en maskin som kan ta in data, kan ge ut data och gör någon slags operation på datan den omsätter.


#let compiler_box(title) = cetz.canvas({
  import cetz.draw: *
  set-style(fill: gray.darken(10%), stroke: black + 2pt)
  let width = 4
  let height = 2
  let attach_height = height / 2
  let outstick_height = height - .2
  let outstick = .9
  let big_width = width + outstick
  line(
    (-width, attach_height),
    (-big_width, outstick_height),
    (-big_width, -outstick_height),
    (-width, -attach_height),
    close: true,
  )
  line(
    (width, attach_height),
    (big_width, outstick_height),
    (big_width, -outstick_height),
    (width, -attach_height),
    close: true,
  )
  set-style(stroke: 2.5pt)
  content((0, height), image("assets/gear.png", height: 4cm))
  rect((-width, height), (width, -height), name: "r")
  content("r.center", anchor: "center", padding: 2mm, text(size: 24pt, fill: white, weight: "bold", title))
})

#align(center, move(
  fletcher-diagram(
    spacing: 3em,
    node-inset: 15pt,
    (
      node((-1, 0), $5$, shape: pill, stroke: 1pt, fill: blue.lighten(90%)),
      node(pos: (0, 0), label: move(compiler_box($ f(x) $), dy: -1cm)),
      node((1, 0), $5 dot 5 + 3$, shape: rect, fill: luma(90%), stroke: 1pt),
      node((2, 0), $27$, shape: pill, stroke: 1pt, fill: blue.lighten(90%)),
    ).intersperse(edge("*-|>")),
  ),
  dy: 1.5cm,
))

== Termonologi inom programmering

I kod använder vi tre nya begrepp:
#table(
  columns: (auto, 1.2fr, 1fr, 1fr),
  inset: (y: 20pt, x: 10pt),
  align: horizon,
  table.header([], [*Parameter*], [*Argument*], [*Returvärdet*]),
  table.vline(x: 1, stroke: 2pt),
  [_Definition_],
  [Det som du deklarerar i *funktionsdefinitionen*],
  [Det som du *passar* till funktionen vid *anropet*.],
  [Det som funktionen *returnerar* efter den körts klart.],

  [_Analog\ i matten_],
  [Har ingen analog i matten.],
  [Motsvarar mattens *argument*],
  [Motsvarar mattens *funktionsvärde*.],
)

== Funktioner som kod

#{
  [De tidigare funktionerna i Python. Vilket är *parametern* och  *returvärdet*?]
  codly(number-format: numbering.with("1"))
  set text(size: 18pt)
  ```py
    def mattefunktion(x):
      return 5 * x + 3

    def andragradsfunktion(x):
        return 5 * x**2 + 2 * x - 3
  ```

  pause

  codly(number-format: none)
  ```
  mattefunktion(5)
  >>> 28

  andragradsfunktion(3)
  >>> 48
  ```
}


== Funktioner med flera indata

Vi är inte begränsade till 1 *parameter*.

#codly(number-format: numbering.with("1"))
```py
def addition(a, b):
    return a + b

def sätt_ihop(del1, del2):
    return "del1: " + del1 + " och del 2: " + del2
```

= Funktionsparametrar

== Variablers synlighet

#slide(composer: (55%, auto))[
  #set text(size: 18pt)
  #codly(
    highlights: (
      (line: 2, start: 5, end: none, fill: green, tag: "Lokal variabel"),
      (line: 3, start: 5, end: none, fill: green, tag: "Lokal variabel"),
      (line: 5, start: 5, end: none, fill: red, tag: "Returvärde"),
    ),
    annotations: (
      (
        start: 2,
        end: 5,
        content: block(
          width: 2em,
          rotate(-90deg, reflow: true, align(center)[Ett *block*]),
        ),
      ),
    ),
  )
  ```py
  def funktion(a, b):
      tal1 = a - 3
      tal2 = b * 3

      return tal1 - tal2
  ```
  - Variabler existerar endast inom sitt *scope*.
    #pause
    - Det heter att den är *lokal* i sitt scope.
    #pause
    - Oftast sammanfaller detta scope med dess *block*.
    #pause
][
  #set text(size: 22pt)
  #item-by-item[
    - Variabler definierade för hela programmet kallas *globala*.
    - Variabler i blocket tar prioritet över globala variabler.
    - Lokala variabler raderas efter att de *går ur scope*.
  ]
  #pause
  #line(length: 100%, stroke: 2pt + au-blå)
  - Alla *funktionsparametrar* är lokala till det scope som utgörs av funktionsblocket.
]

== Funktionsparametern
- Den är alltid lokal till sin funktions block. Vad innebär det?
- Den tilldelas ett värde från argumenten vid anropet.
En mer avancerad funktion:
#alternatives[
  #set text(size: 13.8pt)
  #codly()
  ```py
  def division(dividend, divisor, truncate=False)
    if truncate:
      return dividend // divisor
    else:
      return dividend / divisor
  ```
][
  #set text(size: 13.8pt)
  #codly(
    highlights: (
      (line: 1, start: 14, end: 21, fill: blue, tag: "Parameter 1"),
      (line: 1, start: 24, end: 30, fill: blue, tag: "Parameter 2"),
      (line: 1, start: 33, end: 46, fill: green, tag: "Parameter 3 med default"),
      (line: 3, start: 12, tag: "Trunkerande division", fill: red),
      (line: 5, start: 12, tag: "Decimalbevarande division", fill: red),
    ),
  )
  ```py
  def division(dividend, divisor, truncate=False)
    if truncate:
      return dividend // divisor
    else:
      return dividend / divisor
  ```
]

= Funktionsanropet

== Att anropa en funktion

- Att *anropa* en funktion innebär att man *exekverar* den med en viss indata och eventuellt fångar utdatan.
#pause
- Alla funktionsanrop är på formen: `funktion(arg1, arg2, ...)`.
#pause
- Argument anges i samma ordning som parametrarna är difinierade.
  - Värdet på varje argument kommer att placeras i dess motsvarande parameter.
#alternatives[
  ```py
  def add(a, b):
    return a + b

  add(5, 3)
  ```
][
  #codly(highlights: (
    (line: 4, start: 5, end: 5, fill: blue, tag: "Tilldelas a"),
    (line: 4, start: 8, end: 8, fill: green, tag: "Tilldelas b"),
  ))
  ```py
  def add(a, b):
    return a + b

  add(5, 3)
  ```
]

== Funktionsanrop i uttryck

- Anropet kommer att ersättas av dess returvärde när funktionen har körts klart.

```py
sum = add(3, 4)
```
Vad blev värdet av `sum`?
#pause
Jo:

I `add()` blir `a = 5` och `b = 4`. `a + b = 9`, vilket också blir returvärdet.

Eftersom en funktion ersätts av sitt returvärde i uttryck kommer `sum = 9`.

== Funktionsnarop utan indata

- Om en funktion saknar parametrar behöver den inga argument vid anrop.
- Funktionen kan ändå returnera att värde om det önskas.

#alternatives[
  Ett exempel#footnote[Denna funktion har inget explicit returvärde. Sådana funktioner kallas ibland *procedurer*. Däremot returnerar alla sådana funktioner implicit `None` i Python så detta stämmer inte helt. Av den anledningen används begreppet *procedur* sällen inom Python.]:
  #codly(highlights: (
    (
      line: 4,
      start: 0,
      fill: green,
      tag: "Här körs koden i greet() och som en del av\nfunktionen skrivs medellandet ut.",
    ),
  ))
  ```py
  def greet():
    print("Hej på dig!")

  greet()
  ```
][
  Ett annat exempel med returvärde
  #codly(highlights: (
    (line: 6, start: 7, end: 16, tag: "Returvärdet används för utskrift", fill: green),
  ))
  ```py
  import random

  def roll_die()
    return random.randint(1, 6)

  print(roll_die())

  ```
]


== Funktioner utan utdata

- En funktion kan genomföra operationer utan att omsätta någon data.
- Vanligast är dock att en funktion tar in och/eller ut data åt minst ett håll.

#pause

Ett exempel:

```python
def write_name(name):
    print("Hej! Jag heter: " + name)
    print("Kul att träffas :)")
```
Denna funktion skriver saker på terminalen men har inget returvärde. Kan sällsamt kallas *procedur*.

== Att försöka använda returvärdet av procedurer

- Alla funktioner utan explicit returvärde returnerar implicit `None`.
#pause
- `None` är motsvarande `null`: "ingenting".
  - Detta är inte samma sak som talet `0`.
  - Representerar avsaknaden av information.

#pause
Vad händer om vi sätter en variabel lika med returvärdet av en procedur?
#pause

#alternatives[
  ```py
  def write_name(name):
      print("Hej! Jag heter: " + name)
      print("Kul att träffas :)")

  var = greet("Marcell")
  ```
][
  #codly(highlights: (
    (line: 5, start: 7, tag: "Ersätts med None => var is None", fill: blue),
  ))
  ```py
  def write_name(name):
      print("Hej! Jag heter: " + name)
      print("Kul att träffas :)")

  var = greet("Marcell")
  ```
]
