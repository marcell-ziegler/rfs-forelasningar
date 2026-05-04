import numpy as np
from manimlib import (
    BOLD,
    DOWN,
    LEFT,
    ORIGIN,
    RIGHT,
    UP,
    FadeIn,
    FadeInFromPoint,
    FadeOut,
    FadeOutToPoint,
    FadeTransform,
    Group,
    ImageMobject,
    Polygon,
    Rectangle,
    Scene,
    ShowCreation,
    Text,
    VGroup,
)


class Compiler(VGroup):
    FILL = "#8C8C8C"
    STROKE = "#404040"
    FONT_SIZE = 28

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        center = Rectangle(width=3, height=1.5)
        center.set_fill(self.FILL, 1)
        center.set_stroke(self.STROKE)
        center.move_to(ORIGIN)
        self.add(center)

        left_cone = Polygon(
            center.get_edge_center(LEFT) + UP * 0.3,
            center.get_edge_center(LEFT) + DOWN * 0.3,
            center.get_edge_center(LEFT) + DOWN * 0.6 + LEFT * 0.3,
            center.get_edge_center(LEFT) + UP * 0.6 + LEFT * 0.3,
        )
        left_cone.set_fill(self.FILL, 1)
        left_cone.set_stroke(self.STROKE)
        self.add(left_cone)

        right_cone = left_cone.copy()
        right_cone.apply_matrix(
            np.array(
                [
                    [-1, 0, 0],
                    [0, 1, 0],
                    [0, 0, 1],
                ]
            )
        )
        self.add(right_cone)

        self.phase = "Preprocessing"
        self.title = Text(
            self.phase, font="Open Sans", weight=BOLD, font_size=self.FONT_SIZE
        )
        self.title.move_to(ORIGIN)
        self.title.shift(DOWN * 0.3)
        self.add(self.title)

    def next_phase(self):
        match self.phase:
            case "Preprocessing":
                self.phase = "Compilation"
            case "Compilation":
                self.phase = "Assembly & Linking"
            case "Assembly & Linking":
                self.phase = "Preproccessing"
            case _:
                self.phase = "Preprocessing"

        new = Text(self.phase, font="Open Sans", weight=BOLD, font_size=self.FONT_SIZE)
        new.move_to(ORIGIN)
        new.shift(DOWN * 0.3)
        self.remove(self.title)
        self.old_title = self.title
        self.title = new
        return FadeTransform(self.old_title, self.title)


class CompilationShowcase(Scene):
    def construct(self):
        compiler = Compiler()
        self.add(compiler)

        self.wait(1)

        source = ImageMobject("./source.png")
        source.set_width(3)
        source.set_z_index(-1)
        source.next_to(compiler, LEFT, buff=0.3)

        self.play(FadeIn(source))

        self.wait(1)

        self.play(FadeOutToPoint(source, ORIGIN))

        self.wait(0.1)

        prepro = ImageMobject("./preprocessed.png")
        prepro.set_height(7)
        prepro.set_z_index(-1)
        prepro.next_to(compiler, RIGHT, buff=0.3)
        self.play(FadeInFromPoint(prepro, ORIGIN))

        self.wait(1)
        self.play(prepro.animate.next_to(compiler, LEFT, buff=0.3))
        self.play(compiler.next_phase())

        self.wait(1)
        self.play(FadeOutToPoint(prepro, ORIGIN))

        self.wait(0.1)
        compiled = ImageMobject("./compiled.png")
        compiled.set_height(7)
        prepro.set_z_index(-1)
        compiled.next_to(compiler, RIGHT, buff=0.3)

        self.play(FadeInFromPoint(compiled, ORIGIN))

        self.wait(1)

        compiled.set_z_index(-1)
        self.play(compiled.animate.next_to(compiler, LEFT, buff=0.3))
        self.play(compiler.next_phase())

        self.wait(1)
