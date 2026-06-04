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

== Defaults för parametrar
#item-by-item()[
  - En parameter skriven `param=<default>` kommer anta värdet av `<default>` om inte annat anges i anropet.
  - Sådana parametrar kallas ibland *nyckelordsparametrar*, till skillnad från de andra *positionella parametrarna*.
  - En nyckelordsparameter kan utelämnas om så önskas.
    - Du kan även ange endast vissa nyckelordsparametrar
]

== Exempel på nyckelordsparametrar
#{
  set text(size: 14pt)
  codly()
  ```py
  def print_introduction(name, age, greeting="Hej", punctuation="!"):
      print(f"{greeting}, mitt namn är {name}, jag är {age} år gammal{punctuation}")

  print_introduction("Anna", 15)                      # Hej, mitt namn är Anna, jag är 15 år gammal!
  print_introduction("Melvin", 18, greeting="Goddag") # Goddag, mitt namn är Melvin, jag är 18 år gammal!
  print_introduction("Bertil", 16, "Gomiddag")        # Gomiddag, mitt namn är Bertil, jag är 16 år gammal!
  print_introduction("Clara", 17, punctuation="?")    # Hej, mitt namn är Clara, jag är 17 år gammal?
  ```
}

== Att namnge sin funktion

- Vi använder alltid `snake_case`, engelska rekommenderas.
- Skriv i imperativ: `greet(name)`, inte `greets(name)` t.ex.
- Anväd beskrivande, fullständiga namn:
  - `f(x)`, `y(x)`, `foo(bar)`, `plus(a,b)`, etc. är exempel på mycket dåliga namn!

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

= Dokumentation

== Att dokumentera vad ens kod gör
- I första hand kan du använda kommentarer för att visa vad din kod gör:
  - Inleds med `#`. Det är tillrådligt med mellanslag mellan `#` och kommentar.
- Kommentera rikligt! Däremot ska ni inte kommentera överflödigt#footnote[Nedan exempel, undantaget enhetsanvisningen, skulle jag anse är överflödigt.]!
  ```py
  # En kommentar

  velocity = 5 # m / s

  # Calculate the distance as d = v*t
  distance = velocity * 2
  ```

== Att dokumentera vad en funktion gör --- Docstrings

#item-by-item()[
  - En *docstring* är en särskild sträng, som dokumenterar en funktion.
    - Docstrings skrivs inom tre citattecken (`"""`).
    - Skrivs _alltid_ precis under funktionsdefinitionen, indenterad lika mycket som funktionsblocket.
  - Skriv en för varje funtkion ni gör!
  - Det finns två sorter:
    - Enradiga (enkla)
    - Flerradiga (fullständiga)
]

== Hur skriver man bra docstrings?
En docstring...
#item-by-item[
  - ... skrivs alltid i imperativ och sakligt.
  - ... innehåller alltid:
    - En kort sammanfattning av vad funktionen gör och returnerar. Max 1-2 meningar.
  - ... kan innehålla:
    - En sammanfattning av funktionens parametrar.
    - En sammanfattning av funktionens returvärden.
    - En utförlig beskrivning av funktionens förlopp.
]

== Enradiga docstrings

- Dessa används för att dokumentera enkla funktioner vars funktion är "självförklarliga".
- Använd sparsamt!

Exempel:
#{
  set text(size: 20pt)
  codly(highlighted-lines: (2, 6))
  ```py
  def add(a, b):
    """Add a to b, return the sum."""
    return a + b

  def greet(name):
    """Print a greeting for name."""
    print(f"Hej, {name}!")
  ```
}

== Fullständiga docstrings
#slide(composer: (auto, 1fr))[
  Dessa dokumenterar:
  - Parametrar
  - Returvärden
  - Funktionens syfte

  Skriv alltid sådana om\ möjligheten finns!
][
  #set text(size: 12pt)
  #codly(
    highlighted-lines: range(2, 14),
  )
  ```py
  def divide(dividend, divisor, truncate=False)
    """
    Divide dividend by divisor, return the truncated quotient if truncate == True else return the quotient as float.

    Parameters:
      dividend (int | float): Dividend in the division.
      divisor (int | float): Divisor in the division.
      truncate (bool): Wether to truncate the result. Default: False.

    Returns:
      int: Truncated quotient if truncate == True
      float: Quotioent if truncate == False
    """

    if truncate:
      return dividend // divisor
    else:
      return dividend / divisor
  ```
]

= Rast! (15 min)

= Slingor

== Vad är en slinga?

- Du har nog hört ordet *loop* innan, men vi säger tekniskt sett *slinga* på svenska.
- En *slinga* är ett block som upprepas flera gånger baserat på olika kriterier.
- En slinga utgör ett scope. Varibler definierade i slingan slutar alltså finnas efter slingan.
  - Du kan däremot uppdatera och använda yttre variabler.

== `while`-slingan

#item-by-item()[
  - Slingan upprepar kod _medan_ ett kriterium är `True`.
  - Användbart för:
    - Oändliga slingor
    - Verifiering av indata
    - Viss iteration
]
#pause
Slingan tar formen:
```py
while expr:
  ...
```
Slingang körs så länge `expr == True`. Detta utvärderas i början på varje varv.


== Den oändliga slingan

Den enklaste formen av `while` är den oändliga slingan. Den uppstår när vi låter kriteriet vara `True` alltid. Koden körs för evigt#footnote[Eller tills ett `break` nås, det kommer strax.].

Den oändliga slingan ser ut såhär:
```py
while True:
  ...
```

== Att bryta en slinga tidigt

- Vi använder nyckelordet `break` för att bryta en slinga.
- Detta används särskilt för oändliga slingor, men funkar i vanliga också.

#codly(highlighted-lines: (7,))
```py
prev1 = 1
prev2 = 1
while True:
  next_fib = prev1 + prev2
  print(next_fib)
  if next_fib >= 256:
    break
```

Hur många Fibonaccital skriver vi ut?

== Tillbakablick på algoritmer
#slide[
  Kan någon beskriva koden som en algoritm?
][

  ```py
  prev1 = 1
  prev2 = 1
  while True:
    next_fib = prev1 + prev2
    print(next_fib)
    if next_fib >= 256:
      break
  ```
]
---
#slide[
  Detta är algoritmen. Formatet heter *pseudokod*.
][
  #pseudocode-list([
    + *låt* första talet vara 1
    + *låt* andra talet vara 1
    + *för evigt gör*
      + *låt* nästa fibonaccital vara summan av de två föregående
      + *skriv ut* talet
      + *om* nästa tal >= 256 *gör*
        + *bryt*

  ])
]

== Att hoppa över delar av en slinga
- Med nyckelordet `continue` kan vi hoppa till nästa varv direkt.
#{
  set text(size: 14pt)
  codly(highlighted-lines: (5,))
  ```py
  i = 0
  while True:
      if i == 3:
          i += 1
          continue

      print(f"Nu är i: {i}")
      i += 1

      if i > 5:
          break

  print("klar!")
  ```
}
Vad printas ut?


== `while`-slingor för indatavalidering
En människa är opålitlig, därför måste vi alltid kolla att de givit oss giltig data.

Ett exempel:
```py
number = input("Ange ett positivt heltal: ")

while (not number.isdecimal()) or (int(number) <= 0):
  number = input("Ange ett positivt heltal")
```

== `for`-slingan

#item-by-item()[
  - Denna slinga *itererar* över ett *iterabelt värde*.
  - *Iterabla värden* är:
    - Kollektioner
    - *Generatorfunktioner* (ex. `range()`)
  - För varje varv läggs nästa värde från `iterable` in i `var`.
]

#uncover(3)[
  ```py
  for var in iterable:
    ...
  ```
]

== Iteration över heltalssekvenser
- Vi använder *generatorfunktionen* `range(start, stop=None, step=1)`.
#pause
- I den anger du:
  - `start` som är heltalet som är första elementet i sekvensen.
  - `stop` som är slutet av sekvensen. Talet `stop` inkluderas _inte_ i sekvensen.
    #uncover(3)[
      - Om `stop` inte anges antas `start=0` och det du faktiskt gav som `start` blir `stop`.
    ]
  - `step` som är differensen mellan två tal i sekvensen. Default är 0. Kan vara negativ.

---

Ett exempel:
```py
for i in range(0, 10):
  print(i)
```
Vad skrivs ut?

#pause

Detta är ekvivalent med:
```py
for i in range(10):
  print(i)
```
