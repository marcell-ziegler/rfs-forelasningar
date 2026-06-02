#import "preamble.typ": *
#show: template.with(footer: [Funktioner & upprepningsbar kod])

#title-slide[
  = Programmering --- Föreläsning 2
  Funktioner & upprepningsbar kod

  #v(1cm)

  _Marcell Ziegler_

  #text(size: 18pt, datetime.today().display())
]


== Funktionsbegreppet

Vad är en funktion?

- En funktion är lite som en mekanisk låda:
  #pause
  1. Något går in
  #pause
  2. Det behandlas
  #pause
  3. Och något kanske går ut

== Matematiska funktioner

Ett matematiskt uttryck som tar _argument_ och ger ett _funktionsvärde_.






#columns(2)[
  #set align(center)
  En graf av $f(x) = 5x + 3$
  #image("assets/5x.png", width: 80%)
  #colbreak()
  En graf av $f(x) = 5x^2 - 2x + 3$
  #image("assets/5x2.png", width: 80%)
]

== Funktioner som kod
#{
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

#codly(number-format: numbering.with("1"))
```py
def addition(a, b):
    return a + b

def sätt_ihop(del1, del2):
    return "del1: " + del1 + " och del 2: " + del2
```

== Variablers synlighet


#slide(composer: (55%, auto))[
  #set text(size: 20pt)
  #codly(
    highlights: (
      (line: 2, start: 5, end: none, fill: green, tag: "Start av block"),
      (line: 5, start: 5, end: none, fill: red, tag: "Slut av block"),
    ),
  )
  ```py
  def funktion(a, b):
      tal1 = a - 3
      tal2 = b * 3

      return tal1 - tal2
  ```
][
  #set text(size: 22pt)
  #item-by-item[
    - Variabler existerar endast inom sitt *scope*
      - I dett fall sitt *block*
    - Saker definierade för hela programmet kallas *globala*
    - Variabler i blocket tar prioritet över globala variabler
    - Lokala variabler raderas efter att blocket tar slut
  ]
]

== Funktioner som algoritmer

En funktion kan...
#pause
- ...ha ingen indata, eller ingen direkt utdata
#pause
- ...*exekvera* --- köra --- mer än bara beräkningar

#pause
Ett exempel:

```python
def skriv_namn(namn):
    print("Hej! Jag heter: " + namn)
    print("Kul att träffas :)")
```
