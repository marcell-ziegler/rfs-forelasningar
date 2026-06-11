#import "preamble.typ": *
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/tiptoe:0.4.0"
#show: template.with(footer: [Funktioner, upprepningsbar kod och grundläggande klasser], handout: false)

#title-slide[
  = Programmering --- Föreläsning 2
  Funktioner, upprepningsbar kod och grundläggande klasser

  #v(1cm)

  _Marcell Ziegler_

  #text(size: 18pt, datetime.today().display())
]

== Struktur <touying:hidden>
#[
  #set text(size: 11pt)
  #components.adaptive-columns(outline(title: none))
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
    spacing: (5em, 2em),
    node-inset: 15pt,
    (
      node((-1, 0), $5$, shape: pill, stroke: 1pt, fill: blue.lighten(90%)),
      node(pos: (0, 0), label: move(compiler_box($ f(x) $), dy: -1cm), name: "comp", inset: 0pt, height: 4cm),
      node((1, 0), $27$, shape: pill, stroke: 1pt, fill: blue.lighten(90%)),
    ).intersperse(edge("*-|>")),
    node((0, 1), $5 dot 5 + 3$, shape: rect, fill: luma(90%), stroke: 1pt, name: "process"),
    edge((0, 0), (0, 1), "*-*"),
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
  ```REPL
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
- Kommentera rikligt! Däremot ska ni inte kommentera överflödigt#footnote[Nedan exempel, undantaget enhetsanvisningen, skulle jag anse är överflödigt. Även samtliga labbfacit är överflödiga!]!
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

== Iteration över kollektioner

Ett exempel:

```py
names = ["Martin", "Ida", "Rebecka", "Jonas"]

for name in names:
  print(f"Hej, {name}!")
```
#pause
Ur detta printas:
#{
  set text(size: 18pt)
  ```stdout
  Hej, Martin!
  Hej, Ida!
  Hej, Rebecka!
  Hej, Jonas!
  ```
}

== Iteration över en mängd
Ett exempel:

#{
  set text(size: 18pt)
  ```py
  fruits = {"banana", "apple", "grapefruit", "aubergine", "pomegranate"}

  for fruit in fruits:
      print(fruit)
  ```
}
#pause
Utskriften blir i slumpmässig ordning. Ett exempel:
#{
  set text(size: 12pt)
  ```stdout
  aubergine
  pomegranate
  apple
  grapefruit
  banana
  ```
}


== Iteration över en `dict`
#item-by-item()[
  - I grunden itererar du över `dict`:ens nycklar.
  - Du kan...
    - ...explicit iterera över nycklarna med `my_dict.keys()`
    - ...iterera över värdena med `my_dict.values()`
    - ...iterera båda samtidigt med `my_dict.items()`
]

---

#slide[
  Några exempel:
  #set text(size: 18pt)
  ```py
  film_scores = {
    "Star Wars": 8,
    "Star Trek": 10,
    "Interstellar": 6
  }

  for film in film_scores:
      print(film)
  ```
][
  #set text(size: 11pt)
  ```py
  for film in film_scores:
    print(film)
  ```
  ```stdout
  Star Wars
  Star Trek
  Interstellar
  ```
  #pause
  #line(length: 100%)
  ```py
  for score in film_scores.values():
    print(score)
  ```
  ```stdout
  8
  10
  6
  ```
  #pause
  #line(length: 100%)
  ```py
  for film, score in film_scores.items():
    print(f"Filmen {film} fick betyg {score}/10")
  ```
  ```stdout
  Filmen Star Wars fick betyg 8/10
  Filmen Star Trek fick betyg 10/10
  Filmen Interstellar fick betyg 6/10
  ```
]

== Upprepning av utan iterationsvariabel

Ibland vill man bara kör kod flera gånger. Då gör ni såhär:
```py
for _ in range(4)
  print("Hej")
```
```stdout
Hej
Hej
Hej
Hej
```
#pause
Vi måste ha en *iterationsvariabel*, men vi låter den heta `_` för att visa att vi inte använder den.

== Att smidigt generera listor med comprehensions

- En *`list`-comprehension*#footnote[Dit finns faktiskt comprehensions för annat än listor! Kolla in detta i bokens kapitel #link("https://www.astronomicentrum.se/bok/kollektioner#comprehensions-ett-s-tt-att-bygga-kollektioner", [Kollektioner])] är en speciell `for`-slinga som skapar en lista.
#pause
- Använd gärna detta i stället för att fylla på en tom lista via `for`-slinga!
#pause
Exempel:
#columns(2)[
  #set text(size: 16pt)
  ```py
  import math

  square_roots = [math.sqrt(num) for num in range(4)]
  print(square_roots)
  ```
  ```stdout
  [0.0, 1.0, 1.4142135623730951, 1.7320508075688772]
  ```
  #colbreak()
  ```py
  strings = ["HelLO THerE", "RymDForSKArSKoLAn", "ETT SKRIK"]

  lower_strings = [string.lower() for string in strings]
  print(f"{lower_strings=}")
  ```
  ```stdout
  ['hello there', 'rymdforskarskolan', 'ett skrik']
  ```
]

#speaker-note([
  - Nämn att det finns fler comprehensions!
  - Det går ockås att filtrera, läs på själva!
])

= Rast! (15 min)

= Klasser & Objekt

== Vad är en klass?

#item-by-item[
  - Kort och gott: en datatyp#footnote[Tekniskt sett: en samling attribut (och därav även metoder) som hör till samma gemensamma *namespace*.].
    - En *klass* är en datatyp som representerar något abstrakt
      - föremål,
      - företeelse,
      - fenomen eller
      - allmän "sak".
    - Både datatyper som finns inbyggda och datatyper som du gör själv är egentligen *klasser*.
  - Klasser förekommer rikligt i *objektorienterad programmering* (OOP).
  - Python är ett *objektorienterat språk*; alltså finns det gott om klasser.
]

== Vad är ett objekt?

- Ett *objekt*, också kallat en *instans*, av en klass är en särksild "individ" av den klassen.
  #pause
  - Till exempel: _Maltes_ fotboll vs. en fotboll i allmänhet.
#pause

- Klassen blir då en _kategori_ (en klass) av föremål/fenomen/etc. som du kan skapa olika individer från.
  #pause
  - Ett till exempel: alla heltal du har skapat är ju instanser av klassen `int`! Det vill säga: indivuduella heltal, där `int` är klassen som representerar "saken" heltal.

#focus-slide[
  I Python är _allting_ ett objekt.

  Om inget annat, är de ett objekt av grundklassen `Object`.
]

== Att namnge klasser och objekt

#item-by-item[
  - Alla klasser namnges i `PascalCase`#footnote[Detta gäller inte inbyggda klasser!].
  - Alla objekt, som kommer lagras i variabler, namnges därmed som vanligt i `snake_case`.
  - Alla attribut och metoder namnges i `snake_case` som variabler resp. funktioner.
]

= En rymdresa med stjärnor --- varför har man klasser?

== Stjärnan som variabler

#slide[
  Vi säger att en stjärna kännetecknas av dess:
  - Spektralklass
  - Luminositet
  - Yttemperatur i Kelvin
  - Diameter
  - Massa
  #pause
][
  Detta går ju med vanliga variabler:
  #[
    #set text(size: 18pt)
    ```py
    star1_spectral_klass = "A"
    star1_luminosity = 2.7e6 # W
    star1_surface_temp_K = 4000 # K star1_diameter = 4e8 # m
    star1_mass = 6e6 # kg
    ```
  ]
  #pause
  Det blir dock _många_ variabler...
]

== En lite smidigare lösning
Detta tjänas ju bättre av en `dict`:
```py
star1 = {
    "spectral_class": "A",
    "luminosity": 2.7e6 # W
    "surface_temp_K": 4000 # K
    "diameter": 4e8 # m
    "mass": 6e6 # kg
}
```
#pause
Här blir det dock jobbigt att upprätthålla "standarden" efter ett tag.

== Den bästa lösningen: klasser
#slide(composer: (68%, auto))[
  #set text(size: 16pt)
  #alternatives[
    #codly(highlighted-lines: (1,))
    ```py
    class Star:
      def __init__(
          self,
          spectral_class,
          luminosity,
          surface_temp_K,
          diameter,
          mass
      ):
          self.spectral_class = spectral_class
          self.luminosity = luminosity
          self.surface_temp_K = surface_temp_K
          self.diameter = diameter
          self.mass = mass
    ```
  ][
    #codly(
      highlighted-lines: range(2, 15),
    )
    ```py
    class Star:
      def __init__(
          self,
          spectral_class,
          luminosity,
          surface_temp_K,
          diameter,
          mass
      ):
          self.spectral_class = spectral_class
          self.luminosity = luminosity
          self.surface_temp_K = surface_temp_K
          self.diameter = diameter
          self.mass = mass
    ```
  ][
    #codly(
      highlights: ((line: 3, start: 7, tag: "Specialparameter: förekommer alltid!", fill: blue),),
    )
    ```py
    class Star:
      def __init__(
          self,
          spectral_class,
          luminosity,
          surface_temp_K,
          diameter,
          mass
      ):
          self.spectral_class = spectral_class
          self.luminosity = luminosity
          self.surface_temp_K = surface_temp_K
          self.diameter = diameter
          self.mass = mass
    ```
  ][
    #codly(
      highlights: ((line: 3, start: 7, tag: "Specialparameter: förekommer alltid!", fill: blue),),
      annotations: (
        (
          start: 3,
          end: 8,
          content: block(
            width: 4em,
            rotate(-90deg, reflow: true, align(center)[Parametrar]),
          ),
        ),
      ),
    )
    ```py
    class Star:
      def __init__(
          self,
          spectral_class,
          luminosity,
          surface_temp_K,
          diameter,
          mass
      ):
          self.spectral_class = spectral_class
          self.luminosity = luminosity
          self.surface_temp_K = surface_temp_K
          self.diameter = diameter
          self.mass = mass
    ```
  ][
    #codly(
      highlights: ((line: 3, start: 7, tag: "Specialparameter: förekommer alltid!", fill: blue),),
      annotations: (
        (
          start: 3,
          end: 8,
          content: block(
            width: 4em,
            rotate(-90deg, reflow: true, align(center)[Parametrar]),
          ),
        ),
        (
          start: 10,
          end: 14,
          content: block(
            width: 4em,
            rotate(-90deg, reflow: true, align(center)[Tillsättning\ av attribut]),
          ),
        ),
      ),
    )
    ```py
    class Star:
      def __init__(
          self,
          spectral_class,
          luminosity,
          surface_temp_K,
          diameter,
          mass
      ):
          self.spectral_class = spectral_class
          self.luminosity = luminosity
          self.surface_temp_K = surface_temp_K
          self.diameter = diameter
          self.mass = mass
    ```
  ]
][
  #set text(size: 19pt)
  #uncover("2-")[- Vi definierar en *konstruktor*.]
  #uncover("3-")[
    - *Specialparametern* `self` måste alltid vara med!
      - Den är alltid en referens till det aktuella objektet.
  ]
  #uncover("4-")[- Vi definierar sedan övriga parametrar som krävs _för varje_ *objekt*.]
  #uncover("5-")[- Sist tillsätter vi samtliga *attribut* vi vill ha.]
]

#focus-slide[
  Attribut är inte samma sak som parametrar eller variabler!

  Tillhörighet visas med punktnotation!
]

== Kort om attribut & metoder

- Ett *attribut* _tillhör_ ett objekt eller en klass.
  - Detta visas med *punktnotation*: `obj.attribute`.
    - Här tillhör alltså `attribute` `obj`.
#pause
- En *metod* är en funktion som tillhör en klass eller ett objekt.
  - Detta visas också med punktnotation: `obj.method()`.
  #pause
  - Olika typer av metoder tar specialparametrar (`self` eller `cls`) som måste utelämnas i anropet!

== Att instansiera en klass

- Att *instansiera* betyder att "skapa objekt av".
#pause
- Vi skapar en instans av vår stjärna genom att anropa *konstruktorn*.
  - Detta skrivs som om vi anropar själva klassen!

```py
my-star = Star("B", 5e12, 5125, 4e9, 6.2e8)
```
#pause
- Se hur vi inte angas något värde för `self`!
  - `self` blir ju en referens till det objekt vi skapar!

== Att komma åt attribut
Vi vill kanske använda värden som vi lagrat i `my_star`. Det gör vi ex. såhär:
#table(
  columns: (60%, 1fr),
  stroke: none,
  [
    #set text(size: 15.5pt)
    ```py
    star1 = Star("A", 2.7e6, 4000, 4e8, 6e6)

    # Några rader printout för att kolla vad som registrerades
    lines = [
        "Vår stjärnas egenskaper:",
        f"Spektralklass: {star1.spectral_class}",
        f"Luminositet: {star1.luminosity} W",
        f"Yttemperatur: {star1.surface_temp_K} K",
        f"Diameter: {star1.diameter} m",
        f"Massa: {star1.mass} kg"
    ]
    print("\n".join(lines))
    ```
  ],
  [
    #set text(size: 16.5pt)
    ```stdout
    Vår stjärnas egenskaper:
    Spektralklass: A
    Luminositet: 2700000.0 W
    Yttemperatur: 4000 K
    Diameter: 400000000.0 m
    Massa: 6000000.0 kg
    ```
  ],
)

== Att redigera instansattribut
- Vi kan ändra befintliga och skapa nya:
#[
  #set text(size: 13.5pt)
  ```py
  import math

  star1.luminosity = 2.4e22 # W
  print(f"Stjärnans luminositet är nu: {star1.luminosity} W")

  # Vi tillämpar mantelytan av en sfär
  star1.total_flux = star1.luminosity / (4 * math.pi * (star1.diameter / 2)**2) # W / m^2
  print(f"Totalt radiativt flöde genom ytan är {star1.total_flux:.2f} W / m^2")
  ```
  ```stdout
  Stjärnans luminositet är nu: 2.4e+22 W
  Totalt radiativt flöde genom ytan är 47746.48 W / m^2
  ```
]
#pause
- Eller radera befintliga:
#[
  #set text(size: 14pt)
  ```py
  del star1.total_flux
  ```
]

== Metoder

- En *metod* är en funktion som tillhör en klass eller en instans av en klass.
  - Exempel på metoder ni redan sett är `list.pop()`, `str.lower()` m.m.
  - Dessa metoder tillhör sina respektive klasser `list` och `str`.
#pause
- Vanliga användningar för metoder:
  #pause
  - Beräkningar som berör objektets attribut.
  #pause
  - Utskrifter för olika displayformat av objektets data.
  #pause
  - Olika "handlingar" (procedurer) som objektet kan utföra.
    - Detta är relevant för abstrakta klasser som representerar olika komponenter i ett mjukvarupaket, ex. `HTTPServer` eller dylikt.

== Att skapa våra egna metoder

#slide(composer: (60%, auto))[
  #set text(size: 16pt)
  #codly(highlights: (
    (
      line: 2,
      start: 3,
      tag: "Här utelämnar vi konstruktorn.",
      fill: gray,
    ),
  ))
  ```py
  class Star:
    ...

    def print_summary(self):
        lines = [
            "Vår stjärnas egenskaper:",
            f"Spektralklass: {self.spectral_class}",
            f"Luminositet: {self.luminosity} W",
            f"Yttemperatur: {self.surface_temp_K} K",
            f"Diameter: {self.diameter} m",
            f"Massa: {self.mass} kg"
        ]
        print("\n".join(lines))
  ```
][
  - Denna metod skrivs:
    #pause
    - Indenterat like mycket som klassen.
    #pause
    - Med specialparametern `self`.
      - Vad var det den gjorde?
  #pause
  - Eftersom metoden behandlar attribut på instansen, heter det en *instansmetod*.
]

---

=== Hur man anropar instansmetoder

#[
  #set text(size: 17.3pt)
  ```py
  my_star = Star("B", 3e12, 3125, 5e6, 6e12)

  # Notera hur specialparametern self INTE behöver anges.
  # Den blir automatiskt en referens till objektet
  # metoden anropas på, dvs. my_star.
  my_star.print_summary()
  ```
  ```stdout
  Vår stjärnas egenskaper:
  Spektralklass: B
  Luminositet: 3000000000000.0 W
  Yttemperatur: 3125 K
  Diameter: 5000000.0 m
  Massa: 6000000000000.0 kg
  ```
]

== Instansmetoder som utför beräkningar
#slide(composer: (60%, auto))[
  #set text(size: 16pt)
  ```py
  import math # Superviktigt för att få pi

  class Star:
      ...

      def total_flux(self):
          """Return total flux in W / m^2 for the Star."""
          r = self.diameter / 2
          return self.luminosity / (4 * math.pi * r**2)
  ```
  #uncover("2-")[
    Vi anropar:
    ```py
    my_star = Star("O", 3e14, 3005, 5e5, 6e7)
    print(my_star.total_flux())
    ```
  ]
][
  - En stjänars luminositet ges som
    $ Phi = L / (4 pi r^2). $
  - Till vänster finns en metod som räknar ut denna.
  #v(3em)
  #uncover("2-")[
    #set text(size: 16pt)
    ```stdout
    381.97186342054886
    ```
  ]
]

== Att göra en klass `print()`-kompatibel

#slide(composer: (60%, auto))[
  #set text(size: 16pt)
  ```py
  class Star:
    ...

    def __str__(self):
        lines = [
            "Vår stjärnas egenskaper:",
            f"Spektralklass: {self.spectral_class}",
            f"Luminositet: {self.luminosity} W",
            f"Yttemperatur: {self.surface_temp_K} K",
            f"Diameter: {self.diameter} m",
            f"Massa: {self.mass} kg"
        ]
        return "\n".join(lines)
  ```
][
  - Vi definierar den speciella metoden `__str__()`.
    - Dett berättar för tolken att "det är såhär jag ser ut som text".
  #pause
  - När man anropar print på ett objekt, skrivs den sträng som returneras av `obj.__str__()` ut.
]

---

=== Printa en egen klass

#[
  #set text(size: 17.3pt)
  ```py
  my_star = Star("B", 3e12, 3125, 5e6, 6e12)

  print(my_star)
  ```
  ```stdout
  Vår stjärnas egenskaper:
  Spektralklass: B
  Luminositet: 3000000000000.0 W
  Yttemperatur: 3125 K
  Diameter: 5000000.0 m
  Massa: 6000000000000.0 kg
  ```
]

== Klassattribut
#slide(composer: (55%, auto))[
  #codly(highlighted-lines: range(2, 5))
  ```py
  class Star:
    SOLAR_MASS = 1.989e30 # kg
    SOLAR_LUMINOSITY = 3.828e26 # W
    SOLAR_DIAMETER = 1.3927e9 # m

    def __init__(self, ...)
      ...

    ...
  ```
][
  - Vi kan definiera attribut på klassen som helhet.
    - Detta kallas *klassattribut*.
  #pause
  - Klassattribut är tillgängliga på både klassen och alla instanser.
  #pause
  - Användbart för (ofta konstanta) gemensamma attribut som gäller alla objekt av klassen
]

== Klassmetoder

#slide(composer: (55%, auto))[
  #set text(size: 14pt)
  #codly(highlights: ((line: 6, start: 3, tag: "Här utelämnas __init__() m.m.", fill: gray),))
  ```py
  class Star:
    SOLAR_MASS = 1.989e30 # kg
    SOLAR_LUMINOSITY = 3.828e26 # W
    SOLAR_DIAMETER = 1.3927e9 # m

    ...

    @classmethod
    def from_solar_units(cls, spectral_class, luminosity, surface_temp_K, diameter, mass)
        mass *= cls.SOLAR_MASS
        luminosity *= cls.SOLAR_LUMINOSITY
        diameter *= cls.SOLAR_DIAMETER

        return Star(spectral_class, luminosity, surface_temp_K, diameter, mass)
  ```
][
  #set text(size: 20pt)
  - En *klassmetod* tar `cls` som specialparameter.
    - Detta är analogt med `self`, fast det är en referens till _klassen_, inte objektet.
  #pause
  - Klassmetoder måste *dekoreras* med *dekoratorn* `@classmethod`.
  #pause
  - Notera att det nu är _klassens_ attribut vi kan använda i metoden.
  #pause
  - Vi returnerar returvärdet av konstruktorn, vilket ju är ett nytt objekt med rätt värden!
]

---

=== Exempel på använding
#{
  set text(size: 18pt)
  ```py
  # En Star som har samma egenskaper som solen
  our_sun = Star.from_solar_units("F", 1, 5772, 1, 1)
  print(our_sun)
  ```
  ```stdout
  Vår stjärnas egenskaper:
  Spektralklass: F
  Luminositet: 3.828e+26 W
  Yttemperatur: 5772 K
  Diameter: 1392700000.0 m
  Massa: 1.989e+30 kg
  ```
}

== Ett exempel på en bra docstring
#[
  #set text(size: 12pt)
  #codly(highlights: (
    (line: 17, start: 3, tag: "Här utelämnar vi beräkningar.", fill: gray),
  ))
  ```py
  @classmethod
  def from_solar_units(cls, spectral_class, luminosity, surface_temp_K, diameter, mass):
    """
    Instantiate a Star based on solar units.

    Parameters:
        spectral_class (str): Spectral class of star, e.g. "O","B","A","F","G","K","M".
        luminosity (float): Luminosity in solar luminosity
        surface_temp_K (float): Surface temp in Kelvin
        diameter (float): Diameter in solar diameters
        mass (float): Mass in solar masses

    Returns:
        Star: a new Star object with the provided values converted to SI units.
    """

    ...

    return Star(spectral_class, luminosity, surface_temp_K, diameter, mass)
  ```
]

== Statiska metoder

#slide(composer: (50%, auto))[
  #set text(size: 14pt)
  #codly()
  ```py
  class Star:

    ...

    @staticmethod
    def is_valid_main_seq_spectral_class(spectral_class):
      if spectral_class in ("O", "B", "A", "F", "G", "K", "M"):
          return True
      else:
          return False
  ```
][
  #set text(size: 20pt)
  - En *statisk metod* tar _inga_ specialparametrar!
  #pause
  - Statiska metoder måste dekoreras med dekoratorn `@staticmethod`.
  #pause
  - Notera att vi nu _inte_ kommer åt varken klassens eller instansen attribut.
  #pause
  - Statiska metoder används för att utföra något som inte kräver dessa attribut.
    - Exempelvis att kolla giltigheten av spektralklasser.
  #pause
  - Varför är de då metoder? Jo, för att gruppera likartad kod.
]

== Sammanfattning av klasser
- En klass är en datatyp.
  - Både egna och inbyggda datatyper är klasser.
- Allting i Python är ett objekt, en instans, av en klass.
  - `5` är en instans av `int`.
  - Vår stjärna `my_star` är en instans av `Star`.
- Klasser kan ha:
  - Instansmetoder för att räkna på instansens data.
  - Klassmetoder för att behandla klassens data.
  - Statiska metoder för att gruppera likartad kod.

= Tack för uppmärksamheten!

