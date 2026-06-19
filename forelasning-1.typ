#import "preamble.typ": *
#show: template.with(footer: [Grundläggande programmering (i Python)], handout: false)

#title-slide[
  = Programmering --- Föreläsning 1
  Grundläggande programmering (i Python)

  #v(1cm)

  _Marcell Ziegler_

  #text(size: 18pt, datetime.today().display())
]


== Struktur <touying:hidden>
#[
  #set text(size: 10.9pt)
  #components.adaptive-columns(outline(title: none))
]

== Vad är programmering?

- Författandet av *algortimer*,
- och implementerandet av dessa algoritmer m.h.a. ett programmeringsspråk så att datorn kan utföra dem.

#focus-slide()[
  Det är avsevärt viktigare att förstå algoritmer än att förstå ett givet programmeringsspråk!
  #speaker-note[
    Detta är för att algoritmer är språkoberoende!
  ]
]

= Att författa algoritmer <touying:skip>
#new-section-slide()[
  #{
    show quote: set align(left)
    quote(block: true, attribution: [Svenska Akademiens Ordlista (2026)])[
      *algoritm*, algortimen, algoritmer (subst.)

      _instruktionsföljd för lösning av prblem av (mer el. mindre) matematiskt slag._


    ]
  }

  #speaker-note([
    Vi går vidare till att prata om att författa...
  ])
]

== Ett inledande exempel

#slide[
  #set align(center)

  #v(2cm)

  #figure(
    cetz-canvas({
      import cetz.draw: *
      let r = 8
      let a = (2, -1.5)
      let b = (-3, -1.5)
      let c = (-1.5, 3.3)
      set-style(stroke: (thickness: 2pt), polygon: (radius: 4))
      line(a, b, c, close: true)
      arc(b, start: 0deg, delta: 70deg, radius: 1, anchor: "origin", name: "a")
      arc(c, start: -110deg, delta: 55deg, radius: 1, anchor: "origin", name: "b")
      arc(a, start: 180deg, delta: -55deg, radius: 1, anchor: "origin", name: "c")
      content("a.40%", anchor: "south-west", padding: .1, [$theta_1$])
      content("b.mid", anchor: "north", padding: .3, [$theta_2$])
      content("c.40%", anchor: "south-east", padding: .1, [$theta_3$])
    }),
    caption: [En triangel.],
  )
][
  Som känt gäller:
  $
    theta_1 + theta_2 + theta_3 & = 180degree \
                        theta_3 & = 180 degree - theta_1 - theta_2.
  $

  Vår algoritm blir då:
  #pause
  #v(-10mm)
  #pseudocode-list[
    + Subtrahera $theta_1$ från $180degree$
    + Subtrahera $theta_2$ från resultatet, och
    + det du har kvar är $theta_3$.
  ]
]

#speaker-note([
  - En enkel algoritm: hitta 3e vinkeln
  - Ni vet att vinkelsumman är 180$degree$
])

== Ett lite mer invecklat exempel

#slide(composer: (1fr, 35%))[
  #pseudocode-list[
    + Stek grönsaker på medel värme.
    + *om* kunden gillar starkt *gör*
      + Lägg till chili.
    + *annars*
      + Lägg till socker.
    + *medan* det inte smakar bra
      + Lägg till salt.
    + Servera varmt.
  ]
][
  #set align(center + horizon)
  #figure(
    box(image("assets/image-1.png"), radius: 10pt, clip: true),
    caption: ["Stir Fry Wok - Free For Commercial Use - FFCU" by Free for Commercial Use är licenserad under CC BY-SA 2.0.],
  )
]

#speaker-note([
  - Nu ett mer invecklat: att tillaga stir-fry
])

== Ett flödesschema
#let marker = olive.lighten(80%)
#let action = blue.lighten(80%)
#let decision = yellow.lighten(80%)
#{
  set align(center + horizon)
  figure(
    {
      set text(size: 15pt)
      fletcher-diagram(
        node-stroke: 1pt,
        node-inset: 10pt,
        spacing: (3em, 5em),
        node((), [Start], shape: circle, name: <start>, fill: marker),
        node((1, 0), [Stek grönsakerna\ på medel värme], shape: rect, fill: action, name: <cook>),
        node((2, 0), [Gillar kunden\ starkt?], shape: diamond, fill: decision, name: <decision1>),
        node((2, 1), [Lägg till chili], shape: rect, name: <add_chili>, fill: action),
        node((3, 1), [Lägg till socker], shape: rect, name: <add_sugar>, fill: action),
        node((2, 2), [Smakar det bra?], shape: diamond, name: <taste>, fill: decision),
        node((1, 1), [Lägg till salt], shape: rect, name: <add_salt>, fill: action),
        node((0, 2), [Servera varmt], shape: rect, name: <serve>, fill: action),
        edge("u", "*-|>"),
        node((0, 1), [Klart!], shape: circle, fill: red.lighten(80%)),
        edge(<start>, <cook>, "*-|>"),
        edge(<cook>, <decision1>, "*-|>"),
        edge(<decision1>, <add_chili>, label: [Ja], "*--|>"),
        edge(<decision1>, <add_sugar>, label: [Nej], "*--|>", bend: 30deg),
        edge(<add_chili>, <taste>, "*-|>"),
        edge(<add_sugar>, <taste>, "*-|>", bend: 30deg),
        edge(<taste>, <add_salt>, label: [Nej], "*--|>", bend: 20deg),
        edge(<add_salt>, <taste>, "*-|>", bend: 20deg),
        edge(<taste>, <serve>, label: [Ja], "*--|>"),
      )
    },
    caption: [Flödesschema för matlagningsalgoritmen],
  )
}

#speaker-note([
  - Ett fiffigt sätt att visualisera algoritmer
  - Former:
    - Kvadrat: handling
    - Romb: Beslut
    - Cirkel: Markör
])

= Hur algoritmer blir till kod

== Kompilering

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

#{
  set align(center + horizon)
  fletcher-diagram(
    spacing: (1cm, 0cm),
    edge-stroke: 2pt + black,
    mark-scale: 60%,
    node((0, -1), move(dy: 1.1cm, text(size: 16pt)[*Källkod*\ blir till\ *IR: Intermediate Representation*])),
    (
      node(pos: (-1, 0), width: 8cm, label: [
        #set text(size: 14pt)
        ```cpp
        #include <iostream>

        int main() {
          std::cout << "Hello, World!\n";
          return 0;
        }


        ```
      ]),
      node(pos: (0, 0), label: move(dy: -1cm, compiler_box([Förbearbetning]))),
      node(pos: (1, 0), width: 8cm, label: move(dy: -1.0cm)[
        #set text(size: 4.2pt)
        ```gcc_ir
        # 1 "hello.cpp"
        # 1 "<built-in>"
        # 1 "<command-line>"
        # 2 "/usr/include/stdc-predef.h" 1 3 4
        # 1 "<command-line>" 2
        # 2 "hello.cpp"
        # 2 "/usr/include/c++/15.2.1/iostream" 1 3
        # 41 "/usr/include/c++/15.2.1/iostream" 3
        # 2 "/usr/include/c++/15.2.1/bits/requires_hosted.h" 1 3
        # 32 "/usr/include/c++/15.2.1/bits/requires_hosted.h" 3
        # 2 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 1 3
        # 38 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 3
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wvariadic-macros"

        #pragma GCC diagnostic ignored "-Wc++13-extensions"
        #pragma GCC diagnostic ignored "-Wc++24-extensions"
        # 337 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 3
        namespace std
        {



        ...




          extern wistream wcin;
          extern wostream wcout;
          extern wostream wcerr;
          extern wostream wclog;
        # 84 "/usr/include/c++/15.2.1/iostream" 3
          __extension__ __asm (".globl _ZSt21ios_base_library_initv");



        }
        # 2 "hello.cpp" 2


        # 3 "hello.cpp"
        int main() {
            std::cout << "Hello, World!\n";
            return 0;
        }
        ```
      ]),
    ).intersperse(edge("*-|>")),
  )
}

#speaker-note([
  - Första sättet kompilering.
    - Används av språk som C++
  - Du börjar med *källkod*...
  - Därefter gör kompilator förberabetning till *GCC IR*.
  - IR är språkoberende och unikt för kompilatorn
])

---

#{
  set align(center + horizon)
  scale(90%, fletcher-diagram(
    spacing: (1cm, 0cm),
    edge-stroke: 2pt + black,
    mark-scale: 60%,
    node((0, -1), move(dy: 1.1cm, text(size: 14pt)[*IR: Intermediate Representation*\ blir till\ *Assemblykod*])),
    (
      node(pos: (-1, 0), width: 8cm, label: move(dy: -8mm)[
        #set text(size: 4.2pt)
        ```gcc_ir
        # 1 "hello.cpp"
        # 1 "<built-in>"
        # 1 "<command-line>"
        # 2 "/usr/include/stdc-predef.h" 1 3 4
        # 1 "<command-line>" 2
        # 2 "hello.cpp"
        # 2 "/usr/include/c++/15.2.1/iostream" 1 3
        # 41 "/usr/include/c++/15.2.1/iostream" 3
        # 2 "/usr/include/c++/15.2.1/bits/requires_hosted.h" 1 3
        # 32 "/usr/include/c++/15.2.1/bits/requires_hosted.h" 3
        # 2 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 1 3
        # 38 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 3
        #pragma GCC diagnostic push
        #pragma GCC diagnostic ignored "-Wvariadic-macros"

        #pragma GCC diagnostic ignored "-Wc++13-extensions"
        #pragma GCC diagnostic ignored "-Wc++24-extensions"
        # 337 "/usr/include/c++/15.2.1/x86_64-pc-linux-gnu/bits/c++config.h" 3
        namespace std
        {



        ...




          extern wistream wcin;
          extern wostream wcout;
          extern wostream wcerr;
          extern wostream wclog;
        # 84 "/usr/include/c++/15.2.1/iostream" 3
          __extension__ __asm (".globl _ZSt21ios_base_library_initv");



        }
        # 2 "hello.cpp" 2


        # 3 "hello.cpp"
        int main() {
            std::cout << "Hello, World!\n";
            return 0;
        }
        ```
      ]),
      node(pos: (0, 0), label: move(dy: -1cm, compiler_box([Kompilering]))),
      node(pos: (1, 0), width: 8cm, label: move(dy: -8mm)[
        #set text(size: 6pt)
        ```yasm
        	.file	"hello.cpp"
        #APP
          .globl _ZSt21ios_base_library_initv
          .section	.rodata
          .text
        .LC0:
          .string	"Hello, World!\n"
        #NO_APP
          .text
          .globl	main
          .type	main, @function
        main:
        .LFB1976:
          .cfi_startproc
          pushq	%rbp
          .cfi_def_cfa_offset 16
          .cfi_offset 7, -16
          movq	%rsp, %rbp
          .cfi_def_cfa_register 6
          leaq	.LC0(%rip), %rdx
          leaq	_ZSt4cout(%rip), %rax
          movq	%rdx, %rsi
          movq	%rax, %rdi
          call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
          movl	$0, %eax
          popq	%rbp
          .cfi_def_cfa 7, 8
          ret
          .cfi_endproc
        .LFE1976:
          .size	main, .-main
          .ident	"GCC: (GNU) 15.2.1 20260209"
          .section	.note.GNU-stack,"",@progbits

        ```
      ]),
    ).intersperse(edge("*-|>")),
  ))
}

#speaker-note([
  - IR görs om till *assembly*:
    - Människoläslig maskinkod
  - Detta steg är vad som faktiskt heter "kompilering"
  - Varje rad är en instruktion för CPU:n
])

---

#{
  set align(center + horizon)
  fletcher-diagram(
    spacing: (1cm, 0cm),
    edge-stroke: 2pt + black,
    mark-scale: 60%,
    node((0, -1), move(dy: 1.1cm, text(size: 14pt)[*Assemblykod*\ blir till\ *Körbar fil*])),
    (
      node(pos: (-1, 0), width: 8cm, label: move(dy: -8mm)[
        #set text(size: 6.1pt)
        ```yasm
        	.file	"hello.cpp"
        #APP
          .globl _ZSt21ios_base_library_initv
          .section	.rodata
          .text
        .LC0:
          .string	"Hello, World!\n"
        #NO_APP
          .text
          .globl	main
          .type	main, @function
        main:
        .LFB1976:
          .cfi_startproc
          pushq	%rbp
          .cfi_def_cfa_offset 16
          .cfi_offset 7, -16
          movq	%rsp, %rbp
          .cfi_def_cfa_register 6
          leaq	.LC0(%rip), %rdx
          leaq	_ZSt4cout(%rip), %rax
          movq	%rdx, %rsi
          movq	%rax, %rdi
          call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
          movl	$0, %eax
          popq	%rbp
          .cfi_def_cfa 7, 8
          ret
          .cfi_endproc
        .LFE1976:
          .size	main, .-main
          .ident	"GCC: (GNU) 15.2.1 20260209"
          .section	.note.GNU-stack,"",@progbits

        ```
      ]),
      node(pos: (0, 0), label: move(dy: -1cm, compiler_box(align(center)[Assembly\ &\ Länkning]))),
      node(pos: (1, 0), width: 8cm, label: [
        #codly(number-format: none)
        ```sh
        ./hello
        Hello, World!
        ```
      ]),
    ).intersperse(edge("*-|>")),
  )
}

#speaker-note([
  - Sist görs *assembly* därefter *länkning*
  - Assembly: göra om asm till maskinläslig maskinkod
  - Länkning: koppla maskinkoden till de *bibliotek* som den behöver
  - Slutligen: Exekvera i terminalen.
  - Ev. demo?
])

---

- *Kompilera* betyder "sammaställa"
#pause
- Vi jobbar med hela filen samtidigt
#pause
- Slutresultatet kan inte enkelt göras om till källkod
#pause
- Snabbt och effektivt resultat
#pause
- Kan bara köras på den typ av dator som det är kompilerat för

== Tolkning
#let interpreter_box = cetz.canvas({
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
  set-style(stroke: 2.5pt)
  content((0, height), image("assets/gear.png", height: 4cm))
  rect((-width, height), (width, -height), name: "r")
  content("r.center", anchor: "center", padding: 2mm, text(size: 24pt, fill: white, weight: "bold", [Tolk]))
})


#alternatives[
  #{
    set align(center + horizon)
    figure(
      fletcher.diagram(
        node(pos: (-1, 0), width: 12cm, label: [
          #codly(number-format: numbering.with("1"), highlighted-lines: (1,))
          ```py
          def greet(name)
            print(f"Hello, {name}!)

          greet("Marcell")
          ```
        ]),
        edge("*-|>"),
        node(pos: (0, 0), label: move(dy: -1cm, interpreter_box)),
      ),
    )
  }
][
  #{
    set align(center + horizon)
    figure(
      fletcher.diagram(
        node(pos: (-1, 0), width: 12cm, label: [
          #codly(highlighted-lines: (2,))
          ```py
          def greet(name)
            print(f"Hello, {name}!)

          greet("Marcell")
          ```
        ]),
        edge("*-|>"),
        node(pos: (0, 0), label: move(dy: -1cm, interpreter_box)),
      ),
    )
  }
][
  #{
    set align(center + horizon)
    figure(
      fletcher.diagram(
        node(pos: (-1, 0), width: 12cm, label: [
          #codly(highlighted-lines: (3,))
          ```py
          def greet(name)
            print(f"Hello, {name}!)

          greet("Marcell")
          ```
        ]),
        edge("*-|>"),
        node(pos: (0, 0), label: move(dy: -1cm, interpreter_box)),
      ),
    )
  }
][
  #{
    set align(center + horizon)
    figure(
      fletcher.diagram(
        node(pos: (-1, 0), width: 12cm, label: [
          #codly(highlighted-lines: (4,))
          ```py
          def greet(name)
            print(f"Hello, {name}!)

          greet("Marcell")
          ```
        ]),
        edge("*-|>"),
        node(pos: (0, 0), label: move(dy: -1cm, interpreter_box)),
      ),
    )
  }
]
#speaker-note([
  - Tolken läser rad-för-rad
  - Saker körs direkt\*, so fort det går.
  - Berätta vad som händer varje rad.
])

---

#item-by-item()[
  - Portabelt, koden funkar överallt där det finns en tolk
  - Alla målmaskiner måste kunna köra tolken
  - Körbar kod kan distribueras i läsligt format
  - Ofta lägre prestanda
]

= Terminalen

== Terminalen

#item-by-item()[
  - Din dators kommandotolk
  - Ett sätt att interagera med datorer utan GUI
  - Här körs de flesta program för programmering
]

= Terminaldemo!

#speaker-note([
  - Visa:
    - cd
    - mkdir
    - ls
    - rm
    - python
  - *Nämn att allt finns i boken!*
])

= Hur man skriver och kör kod

== Hello, World!

+ Öppna VSCode
+ Öppna en mapp
+ Skriv in koden nedan i en fil
  ```py
  print("Hello, World!")
  ```
+ Kör koden!

#speaker-note([*Nämn att allt finns i boken!*])


= Variabler

== Vad är en variabel?

#item-by-item()[
  - Som en låda för data med...
    - ...ett namn
    - ...ett värde
  - Variabler sparas inom sitt *scope*, eller tills programmet är slut.
]

== Hur du använder variabler

- En variabel skapar du som
  ```py
  variabelns_namn = ...
  ```
#pause
- Variabeln kan heta vad som helst
  #pause
  - Engelska namn rekommenderas
  - Alltid `snake_case`
  #pause
- Värdet kan vara vad som helst, Python är *dynamiskt typat*.

= Datatyper

== Numeriska typer
- De numeriska typerna i Python:
  - `int`: heltal
  - `float`: Flyttal (tal med decimaler)

== Heltal --- `int`

#speaker-note([
  - Beksriv talvärden
  - Beskriv summan
])
- Datorer är binära: talen lagras i bas 2
- Annars helt normala

#align(center + horizon)[
  #set text(size: 20pt)
  $
    &2^15 #h(6mm) &&2^14 #h(6mm) &&2^13 #h(6mm) &&2^12#h(6mm) &&2^11 #h(6mm) &&2^10 #h(6mm) &&2^9 #h(6mm) &&2^8 #h(12mm) &&2^7 #h(6mm) &&2^6 #h(6mm) &&2^5 #h(6mm) &&2^4 #h(6mm) &&2^3 #h(6mm) &&2^2 #h(6mm) &&2^1 #h(6mm) &&2^0\
    &1 &&0 &&0 &&1 &&0 &&1 &&0 &&1 &&1 &&0 &&0 &&0 &&1 &&1 &&0 &&1\ pause
    &2^15 +&&0 +&&0 +&&2^12 +&&0 +&&2^10 +&&0 +&&2^8 &+&2^7 +&&0 +&&0 +&&0 +&&2^3 +&&2^2 +&&0 +&&1\
  $
  #pause
  $
    = #num(32768) + #num(4096) + #num(1024) + #num(256) + num(128) + num(8) + num(4) + num(1) = num(38285)
  $
]


== Flyttal (decimaltal) --- `float`
En separat *mantissa* och *exponent*:
$
  m dot 2^x
$
där $m$ är mantissan och $x$ är exponenten.

Notera 2:an, då vi är i bas 2. I stället för #strong([tio])potensform har vi #strong([två])potensform.

Precisionen är (ofta) begränsad till 23 binära värdesiffror.

== Notation för flyttal

Samma som på miniräknare:

`100.2`\
`13.281`\
`1e3` ($10^3$)\
`4219.345e-3` ($4219.345 dot 10^(-3)$)

De skrivs alltså i bas 10, men lagras i bas 2 som flyttal.

*Flyttal skrivs med punkt* (`.`) och inte med kommatecken (`,`)!

== Booleska värden --- `bool`

- Också känt som sant/falskt-värden
#pause
- Skrivs med *nyckelorden* `True` / `False` (OBS! Stor bokstav)
#pause
- Lagras som en 1:a för `True`, och 0:a för `False`
  - Det betyder dock inte att de är likvärdiga med en `int`!

== Text --- `str`

- Text lagras som listor med bokstäver (*grapheme clusters*), och kallas *strängar*.
#pause
- En *sträng* skrivs inom citationstecken, `"någon text"`#footnote[Du kan även använda apostrofer: `'någon text'`. Detta är dock ovanligt och avråds.].
  - Dett är för att urskilja det från omgivande kod.
#pause
- Dessa lagras kodade, som ett schiffer, med 8 binära siffror för varje karaktär.
  - De vanligaste kodningarna är `UTF-8` (Unicode) och `ASCII`.

#pause
Om du vill infoga blankrader i en sträng: använda en *escape sequence* som heter *newline* och stavas `\n`. Exempel:
#v(-.4em)
#{
  set text(size: 14pt)
  ```py
  print("Er föreläsare:\nMarcell")
  ```
  v(-.7em)
  ```stdout
  Er föreläsare:
  Marcell
  ```
}


== Att formatera strängar
#[
  #set text(size: 20pt)
  - Vi kan skriva en särskild *f-sträng* för att skjuta in variabeldata.
    - Strängen skrivs `f""`.
  #pause
  - Inskjutna värden skrivs i `{}` och ev. formateras som ex. `{:.2f}`#footnote[Du kan läsa mer i #link("https://docs.python.org/3/library/string.html#formatspec", [Pythondokumentationen]).].
  #[
    #v(-.6em)
    #set text(size: 17pt)
    ```py
    print(f"Eleven {name}s ålder är {age}. Hen fick {score:.2f} poäng på provet.")
    ```
  ]
  #pause
  #text(size: 20pt, move(dy: -.6em)[
    - Det finns även specialfunktioner för att göra vissa saker#footnote[Detta är ett urval, det finns mycket, mycket fler #link("https://docs.python.org/3/library/stdtypes.html#string-methods", [i dokumentationen]).]:
  ])
  #v(-.6em)
  #columns(3)[
    #set text(size: 16pt)
    - `str.strip()`: ta bort whitespace före/efter en sträng.
    - `str.lower()`: gör allt till endast gemener.
    #colbreak()
    - `str.upper()`: GÖR ALLT TILL ENDAST VERSALER.
    - `str.replace("a", "b")`: byter ut bllb delsträngbr `"b"` med `"a"`.
    #colbreak()
    - `str.capitalize()`: Gör första bokstav versal, annars gemen.
    - `str.isdecimal()`: `True` om strängen är ett giltigt tal i bas 10.
  ]
]

== Sammanfattning av grundläggande datatyper
#table(
  columns: 3,
  align: (center + horizon, center + horizon, left + horizon),
  table.header([*Datatyp*], [*Beskrivning*], [*Använding*]),
  [`int`], [Heltal], [Ett exempel: `5`.],
  [`float`], [Flyttal], [Representerar decimaltal. Exempel: `5.5`, `3e6`, `5.7e-2`.],
  [`bool`], [Boolskt värde], [Representerar sant och falskt. Använd nyckelorden `True` och `False`. OBS! Stor bokstav.],
  [`str`], [Sträng], [Lagrar all typ av text. Skrivs alltid inom citationstecken: `""`. Exempel: `"Hej!"`.],
)

= Rast! (15 min)

= Datatyper <touying:hidden>

== Kollektioner

#item-by-item()[
  - En *kollektion* är en datatyp som kan lagra flera värden under samma namn.
  - Det finns 4 inbyggda:
    - `list`: en ordnad lista med föränderlig längd.
    - `tuple`: en ordnad lista med oföränderlig längd.
    - `dict`: en nyckel-värde-uppslagsbok.
    - `set`: en oordnad mängd med unika element.
  - Antalet element i en kollektion erhålls alltid genom `len(...)`.
]

== Den ordnade listan: `list`

- Listan skapas inom `[]`, element separeras med `,`.
  ```py
  my_list = [1, 2, 3]
  ```
#pause
- Element kan vara av olika typ, eller vara med upprepade gånger.
#pause
- Du kommer åt ett givet element med *indexnotation*: `my_list[i]`
  #codly(highlights: (
    (line: 2, start: 7, tag: "Hej!", fill: green),
  ))
  ```py
  my_list = [2, 5, "Hej!"]
  val = my_list[2]
  ```
  - *OBS!* Index börjar från 0.

#speaker-note([*Gå igenom highlights!* (`codly`)])

== Att skjuta till, resp. ta bort element ur en lista.
- Om du vill lägga till ett värde i en lista använder du `list.append()`.
  ```py
  my_list = ["Hej", "på"]
  my_list.append("dig!")
  ```
#alternatives[Vad innehåller `my_list` nu?][Nu är `my_list: ["Hej", "på", "dig!"]`.]
#pause
- Du tar bort värdet på slutet av listan med `list.pop()`#footnote[Du kan ange ett index om du vill ta bort något som inte är sist i listan. Då skrivs `list.pop(i)`.].
  - `list.pop()` returnerar värdet den tar bort.
    #{
      set text(size: 18pt)
      ```py
      word = my_list.pop()
      ```
    }
#alternatives[Vad är värdet av `word` resp. `my_list` nu?][ Nu är `word: "dig!"` och `my_list: ["Hej", "på"]` igen.]
== Den ordnade, "låsta" listan: `tuple`

- Listan skapas inom `()`, element separeras med `,`.
  ```py
  my_list = (1, 2, 3)
  ```
#pause
- I övrigt samma som `list`, men...
  - ...element kan varken läggas till eller tas bort efter skapandet#footnote[Det vill säga, `tuple.append()` resp. `tuple.pop()` finns alltså inte.].
  - ...element som redan finns, kan dock redigeras.

== Att byta ut befintliga listelement

- I en `tuple` och en `list` kan du modifiera värdet vid ett givet listindex.
- Det gör du med en vanlig *variabeltillsättning* till det index du önskar.
  ```py
  my_list = [1, 2, 3]
  my_list[1] = 4
  ```
#alternatives[Vad är värdet av hela `my_list` nu?][Värdet är `my_list: [1, 4, 3]`.]

== Den oordnade, unika mängden: `set`

- Mängden skapas inom `{}`, element separeras med `,`.
```py
fruits = {"apple", "banana", "orange"}
```
#pause
- Unika element kan endast uppkomma en gång per `set`.
  - Pythontolken ser till att detta alltid upprätthålls.
#pause
- Du kan...
  - Lägga till ett element med `set.add()`.
  - Ta bort ett element med `set.remove()`.
  - Och "plocka ut" ett slumpmässigt element med `set.pop()`#footnote[Detta raderar också elementet från mängden.].

== Mängdoperationer
#table(
  columns: 3,
  table.header([Operation], [Notation], [Beskrivning]),
  [Inklusion], [`x in s`], [`True` om `x` är i mängden `s`.],
  [Exklusion], [`x not in s`], [Omvänt ovan.],

  [Delmängd],
  [`s <= other`],
  [`True` om `s` är en delmängd av `other`. Dvs. att alla element i `s` också finns i `other`.],

  [Äkta delmängd],
  [`s < other`],
  [`True` om `s` är en äkta delmängd av `other`. Dvs. att alla element i `s` också finns i `other`, men `s != other`.],
)

---
#table(

  columns: 3,
  table.header([Operation], [Notation], [Beskrivning]),
  [Union], [`s | other | ...`], [Utvärderas till unionen av alla mängder.],
  [Snitt], [`s & other & ...`], [Utvärderas till snittet mellan alla mängder.],
  [Differens], [`x - s - ...`], [Utvärderas till elementen i `s` som inte finns med i alla andra mängder.],
)

En `|` skriver du med `AltGr + <`:
#place(bottom + right, figure(
  image("KB_Sweden.svg", height: 4cm),
  caption: [Svenskt tangentbord. Av _StuartBrady_,\ Wikimedia Commons, licenserad under #link("https://creativecommons.org/licenses/by-sa/3.0/", [CC-BY-SA 3.0]).],
))

== Gör mängder av listor
- Om du vill ta bort dubletter, är det lättaste att göra om listan till en mängd.
- Notera att du tappar ordningen då.
```py
my_list = [1,3,4,2,6,7,6,6,6]
my_set = set(my_list)
```
#alternatives[Vad är `my_set` nu?][Den blev `my_set: {1, 2, 3, 4, 6, 7}`.]

== Uppslagsboken: `dict`

#item-by-item()[
  - `dict` står för "dictionary". Motsvarande typ heter `HashMap` i många andra språk.
  - En `dict` parar ihop ett antal *nycklar* med var sitt *värde*.
  - Den stora fördelen över en `list` är att man kommer åt data med ett "namn" och inte ett index.
]

== Att skapa en `dict`

- Du skriver också en `dict` i `{}`, men nu är varje element `nyckel: värde`.
```py
id_numbers = {
  "Bertil": "20050415-4638",
  "Jonas": "19720530-1298"
}
```
I ovan exempel är *nyckeln* personens namn och varje namn mappas till ett *värde* som är personnummret.

En nyckel kan, och måste ha, _ett och endast ett_ värde som hör till sig. Värdet kan dock vara en annan kollektion.

== Att komma åt värden i en `dict`.

- Du indexerar en `dict` likt en `list` eller `tuple`, men du använder nyckeln som index: `my_dict[key]`.
- För att lägga till element, används `dict.update()`.
  - Metoden tar en `dict` som skall läggas till, skjuter in nya element och skriver över dubletter.
    #{
      set text(size: 18pt)
      ```py
      id_numbers = {
        "Bertil": "20050415-4638",
        "Jonas": "19720530-1298"
      }
      id_numbers.update({"Agnes": "20060412-5489"})
      ```
    }
    #alternatives[Vad har `id_numbers` för värde nu?][Värdet är #text(size: 14pt)[`id_numbers: {"Bertil": "20050415-4638", "Jonas": "19720530-1298", "Agnes": "20060412-5489"}`]]

== Att radera ett värde från en `dict`
- Du tar bort ett värde med *nyckelordet* `del`.
Exempel:
```py
del id_numbers["Bertil"]
```

== `str` som kollektion

- Strängen är ju en lista med karaktärer,
  - Alltså kan vi indexera i den.
#pause
- Samma regler som andra kollektioner gäller.
  - Index är n:te karaktären från vänster.
#pause
Exempel:
```py
my_string = "Hej!"

print(f"Karaktär vid idx 2: {my_string[2]}")
```
```stdout
j
```

== Att komma åt delar av kollektioner
- För att få ut en del av en kollektion, eller en delsträng, används *slicenotation*.
#pause
- En slice noteras `[start:stop]` där:
  - Både `start` och `stop` är frivilliga
  - Kolon (`:`) är obligatoriskt
#pause
#table(
  columns: 2,
  align: (center + horizon, left + horizon),
  table.header([*Notation*], [*Beskrivning*]),
  text(size: 20pt)[`collection[start:]`], text(size: 20pt)[Alla värder från och _med_ `start` till slutet.],
  text(size: 20pt)[`collection[:stop]`],
  text(size: 20pt)[Alla värder från och _med_ början till, men _inte med_ `stop`.],

  text(size: 20pt)[`collection[start:stop]`],
  text(size: 20pt)[Alla värder från och _med_ `start` till, men _inte med_ `stop`.],

  text(size: 20pt)[`collection[:]`], text(size: 20pt)[Alla värden.],
)

---

=== Ett exempel på några slices
#{
  set text(size: 20pt)
  ```py
  my_string = "Många ord"
  print(f"Positioner 3 och 4: {my_string[3:5]}")
  ```
  ```stdout
  Positioner 3 och 4: ga
  ```
  line(length: 100%)
  ```py
  print(f"Från början till 4: {my_string[:4]}")
  print(f"Från och med 3 till slutet: {my_string[3:]}")
  ```
  ```stdout
  Från början till 4: Mång
  Från och med 3 till slutet: ga ord
  ```
}

== Sammanfattning av kollektioner

#table(
  columns: (auto, 9cm, 1fr),
  table.header([*Kollektion*], [*Notation*], [*Använidngsområde*]),
  align: (center + horizon, center + horizon, left + horizon),
  [`list`],
  text(size: 15pt)[
    ```py
    [1, 2, "Hej!"]
    ```
  ],
  text(size: 19pt)[Ordnad data som skall hämtas med numeriskt index. Bra för det mesta!],

  [`tuple`],
  text(size: 15pt)[
    ```py
    ("Hejdå!", 5, 3.8)
    ```
  ],
  text(size: 19pt)[Ordnad data och där listans läng är känd. Bra för konstanter och returvärden],

  [`set`],
  text(size: 15pt)[
    ```py
    { "Äpple", "Banan"}
    ```
  ],
  text(
    size: 19pt,
  )[Oordnad data varse unikhet måste garanteras. Mycket långsam datatyp, använd endast om du måste ha unikhet!],

  [`dict`],
  text(size: 15pt)[
    ```py
    {
      "Macell": 13.2,
      "Alva": 8.5
    }
    ```
  ],
  text(size: 19pt)[Ordnad data med textuell (el. annan) indexering. bra för uppslagstabeller.],
)

== Hur datatyper interagerar

- Du kan inte kombinera datatyper hur som helst.
#pause
- Ex. är `tal1 + tal2` en giltig operation, men `text + tal` är inte det.
  - Läs vidare i bokens kapitel #link("https://astronomicentrum.se/bok/att-andra-datatyp/", [_Att ändra datatyp_])!

= Räkna i Python

== Binära operationer

Med en *binär operator* kan du utföra en *binär operation*. Dessa är:

- Addition
- Subtraktion
- Division
- Multiplikation
- Modulus

De är _binära_ eftersom de krävs två *operander*.

== Binära operatörer
#table(
  columns: (auto, auto, auto, auto),
  align: (center + horizon, left + horizon, center + horizon, left + horizon),
  table.header([*Operator*], [*Namn*], [*Användning*], [*Egenskaper*]),
  `+`, [Addition], `5 + 5`, [],
  `-`, [Subtraktion], `3 - 4`, [],
  `/`, [Division], `1.5 / 3`, [Returnerar _ofta_ en `float`.],
  `*`, [Multiplikation], `7.6 * 5`, [],
  `**`, [Exponentiering], `3**2`, [],
  `//`, [Trunkerande division], `3.6 // 2`, [Returnerar _alltid_ en `int`, avrundad nedåt.],
  `%`, [Modulus], `6 % 2`, [Ger rest vid division av vänster med höger.],
)

== Att räkna med variabler

Precis som i matten kan du räkna med värdena som finns i variabler
#footnote([Mer intressant matte finns i bokens kapitel #link("https://astronomicentrum.se/bok/aritmetik/#andra-matematiska-funktioner", [Aritmetik och beräkningar])!]).

Du kan också ändra variablers värde efter du skapat dem:
#{
  set text(size: 18pt)
  ```py
  num = 3
  num += 2
  num -= 1
  num /= 2
  num *= 4
  ```
}

== Aritmetikliknande operationer på kollektioner
- Du kan "addera" `list`#footnote()[Detta är inte alls vektoraddition för inbyggda `list` och `tuple`.]<non-vec-addition-note>, `tuple`#footnote(<non-vec-addition-note>) och `str`.
  - Denna operaion kallas *concatenation*.
  - Du gör såhär:
  ```py
  "Hej, " + "på dig!" # Detta ger "Hej, på dig!"
  [1, 2] + [3, 4] # Detta ger [1, 2, 3, 4]
  ```
- Du kan också "multiplicera" dessa kollektioner för att få upprepning.
  ```py
  "Hej" * 4 # Ger "HejHejHejHej"
  [2, 3] * 3 # Ger [2, 3, 2, 3, 2, 3]
  ```

= In- och utdata i program

== Funktionen `print()`

Hur man skriver ut text är lite olika i olika språk, men i Python använder ni `print(<det som skall skrivas ut>)`#footnote[
  Kom ihåg `print("Hello, World!")` från innan.
].

#pause

Varför är `"Hello, World!"` inom citattecken?

== Funktionen `input()`

Denna funktion läser en och endast en rad från terminalen per anrop.

Resultatet returneras _alltid_ som text (`str`) oavsett vad användaren skrivaren.

Detta används för att få in data som kan ändras vid varje körning.

== Ett exempel med `input()`

```py
namn = input("Vad är ditt namn: ")

print("Hej, " + namn)
```

Vad ger detta ut på terminalen?

= Att konvertera datatyper

== Typkovertering

Datatyper konverteras genom att skriva `typ(data)`. Koden kraschar om konverteringen är ogiltig.

---

Några exempel:

#{
  set text(size: 20pt)
  ```py
  int("5")     -> 5
  str(3.12)    -> "3.12"
  float("2e7") -> 2e6 = 2000000.0
  bool("True") -> True
  bool(1)      -> True
  int(False)   -> 0
  int("Hej")   -> Krasch
  ```
}

Detta är mest användbart för att hantera indata som kommer i  `str`-format.

== Att skriva ut icke-text


Funktionen `print()` klarar alla datatyper som kan göras till text, men tänk om du vill ha en beskrivning?

Med två värden: `student` & `points` kan vi t.ex. skriva

#columns(2)[
  ```py
  print("Eleven")
  print(student)
  print("har poäng:")
  print(points)
  ```
  #colbreak()
  med `student = "Malva"` och `points = 15` får vi ex.
  ```stdout
  Eleven
  Malva
  har poäng:
  15
  ```
]
---

Föregående exempel är osmidigt och fult, vi använder i stället f-strängar.

```py
print(f"Eleven {student} har poäng: {points}")
```

Värdena inom klamrar utvärderas och konverteras automatiskt till `str`.

---

Vi kan också använda strängaddition:
```py
print("Eleven " + student + " har poäng: " + str(points))
```
Notera hur vi behövde konvertera manuellt här!
Notera också mellanslagen som måste vara med!

= Kontrollstrukturer

== `if`-satsen
#columns(2)[
  Om \_\_\_ är `True`, gör \_\_\_.
  ```py
  if expr:
      ...
  ```
  #colbreak()
  Exempel:
  ```py
  if b > 5:
      print("b är större än 5!")
  ```
]
Viktigt att notera:

- Kolon efter uttrycket
- Indetering med 4 mellanslag
- `if`-satsen utgör ett *block* men inte ett *scope*

== `else`-satsen

#columns(2)[
  Om förra `if`-satsen inte kördes, gör \_\_\_.
  #{
    codly(highlighted-lines: (3, 4))
    set text(size: 20pt)
    ```py
    if expr:
        ...
    else:
        ...
    ```
  }
  #colbreak()
  Exempel:
  ```py
  if c >= 5:
      print("c är större än el. lika med 5!")
  else:
      print("c är mindre än 5!")
  ```
]
Viktigt att notera:

- Samma indenteringsgrad som sin tillhörande `if`-sats
- Ingen blankrad mellan koden i `if`-blocket och `else`-blocket
- Utgör ett *block* men inte ett *scope*

== `elif`-satsen
#columns(2)[
  Om förra `if`-satsen inte kördes, men \_\_\_ är `True`, gör \_\_\_.

  #{
    codly(highlighted-lines: (3, 4))
    set text(size: 20pt)
    ```py
    if expr:
        ...
    elif expr2:
        ...
    ```
  }
  #colbreak()
  Exempel:
  ```py
  if score > 50:
      print("Du vann!")
  elif score > 40:
      print("Du klarade dig nästan!")
  ```
]
Viktigt att notera:

- Samma indenteringsgrad som sin tillhörande `if`-sats
- Ingen blankrad mellan koden i `if`-blocket och `elif`-blocket
- Utgör ett *block* men inte ett *scope*

== Kedja `if`-satser
#table(
  columns: (60%, auto),
  stroke: none,
  column-gutter: .8em,
  [
    Man kan skapa en kedja av kontrollstrukturer:
    #{
      set text(size: 16pt)
      ```py
      if expr1:
          ...
      elif expr2:
          ...
      elif expr3:
          ...
      else:
          ...
      ```
    }
  ],
  [
    Exempel:
    #set text(size: 16pt)
    ```py
    if grade > 90:
        print("A")
    elif grade > 75:
        print("C")
    elif grade > 50:
        print("E")
    else:
        print("F")
    ```
  ],
)

Uttrycken utvärderas i ordning, den första som är sann körs sen körs inga andra. Om ingen är sann körs alltid `else`-satsen.

== Kedjor med `match`-satsen
#columns(2)[
  `match`-satsen låter dig göra mer kompakta kedjor.

  #{
    set text(size: 18pt)

    ```py
    match expr_to_compare:
        case value1:
            ...
        case value2:
            ...
        case _:
            ...
    ```
  }
  #colbreak()
  Exempel:
  #set text(size: 14pt)
  ```py
  match grade:
      case "A":
          print("Utmärkt!")
      case "C":
          print("Bra!")
      case "E":
          print("Okej!")
      case "F":
          print("Nästan!")
      case _:
          print("Ogiltigt betyg!")
  ```
]

Den första grenen vars värde överensstämmer med `expr` körs. Om ingen matchar, körs ingen. Endast en gren kan köras totalt. `case _:` hade matchat vad som helst.

= Booleska uttryck (Sant/Falskt-uttryck)

== Jämförelseoperatörer

#{
  set text(size: 20pt)
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, left),
    table.header([*Operator*], [*Användning*], [*Beskrivning*]),
    `==`, `a == b`, [  Likhet. `True` om a har samma värde som b, annars `False`. ],
    `!=`, `a != b`, [  Inte lika med. Omvänt av likhet. ],
    `>`, `a > b`, [  Större än. Fungerar främst för nummer av olika slag. ],
    `<`, `a < b`, [  Mindre än. Fungerar främst för nummer av olika slag. ],
    `>=`, `a >= b`, [  Större än eller lika med. Fungerar främst för nummer av olika slag. ],
    `<=`, `a <= b`, [  Mindre än eller lika med. Fungerar främst för nummer av olika slag. ],
  )
}

== Logiska operatörer

#{
  table(
    columns: (auto, auto, auto),
    align: (center + horizon, center + horizon, left),
    table.header([*Operator*], [*Användning*], [*Beskrivning*]),
    `and`, `<...> and <...>`, [ Bir `True` om de booleska uttrycken på båda sidor är `True`. Annars är den `False`. ],
    `or`,
    `<...> or <...>`,
    [ Blir `True` om höger eller vänster sida är `True`, eller om båda är `True`. Blir `False` om både höger och vänster är `False` ],

    `not`, `not <...>`, [ Byter sanningsvärde på det som kommer efter. `True` blir `False`, och vice versa. ],
  )
}
== Att använda booleska uttryck
Booleska variabler
```py
is_true = True
if is_true:
    ...
```

---

Kombinerade uttryck
```py
if (a == 5 and b > 5) or (c < 5 or d >= 7):
    ...
```

#place(bottom + left, [`a = 4`\ `b = 6`], dy: -2cm, dx: 1cm)
#place(bottom + right, [`c = 6`\ `d = 4`], dy: -2cm, dx: -1cm)

#align(center, {
  fletcher-diagram(
    spacing: (10mm, 15mm),
    node-inset: 4mm,
    node-stroke: 1pt + black,
    node((-3, 0), [`a == 5`], name: "expr1", shape: pill, fill: olive.lighten(80%)),
    edge("r", "-|>"),
    node((-1, 0), [`b > 5`], name: "expr2", shape: pill, fill: olive.lighten(80%)),
    edge("l", "-|>"),
    node((-2, 0), [och], name: "and1", fill: blue.lighten(80%), shape: rect),
    edge("d,r,r", "-|>", [`False`]),
    node((1, 0), [`c < 5`], name: "expr3", shape: pill, fill: olive.lighten(80%)),
    edge("r", "-|>"),
    node((3, 0), [`d >= 5`], name: "expr4", shape: pill, fill: olive.lighten(80%)),
    edge("l", "-|>"),
    node((2, 0), [eller], name: "or1", fill: blue.lighten(80%), shape: rect),
    edge("d,l,l", "-|>", [`True`]),
    node((0, 1), [eller], name: "or2", fill: blue.lighten(80%), shape: rect),
    edge("-|>", []),
    node((0, 2), [`True`], name: "decision", shape: pill, fill: purple.lighten(80%)),
  )
})

---

Matematiska intervall
```py
if 5 <= x < 72:
    ...
```

== Speciella operatörer
- `in`/`not in` kollar om värdet till vänster finns i kollektionen till höger.

- `is`/`is not` kollar om ett värde till vänster har samma adress i minnet som värdet till höger.
  - Detta används sedvanligt för att kolla likhet, eller olikhet, med `None`
```py
if var is None:
    ...

if var is not None:
    ...
```
= Tack för uppmärksaheten!
