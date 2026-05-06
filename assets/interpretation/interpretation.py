import numpy as np
from manimlib import (
    BOLD,
    DEGREES,
    DOWN,
    LEFT,
    ORIGIN,
    RIGHT,
    TOP,
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
    always,
)


class Compiler(Group):
    FILL = "#8C8C8C"
    STROKE = "#404040"
    FONT_SIZE = 28

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.gear = ImageMobject("./gear.png")
        self.gear.set_height(2)
        self.gear.shift(1.5 / 2 * UP)
        always(self.gear.rotate, 2 * DEGREES)
        self.add(self.gear)

        self.center_rect = Rectangle(width=3, height=1.5, z_index=5)
        self.center_rect.set_fill(self.FILL, 1)
        self.center_rect.set_stroke(self.STROKE)
        self.center_rect.move_to(ORIGIN)
        self.add(self.center_rect)

        self.left_cone = Polygon(
            self.center_rect.get_edge_center(LEFT) + UP * 0.3,
            self.center_rect.get_edge_center(LEFT) + DOWN * 0.3,
            self.center_rect.get_edge_center(LEFT) + DOWN * 0.6 + LEFT * 0.3,
            self.center_rect.get_edge_center(LEFT) + UP * 0.6 + LEFT * 0.3,
        )
        self.left_cone.set_fill(self.FILL, 1)
        self.left_cone.set_stroke(self.STROKE)
        self.add(self.left_cone)

        self.right_cone = self.left_cone.copy()
        self.right_cone.apply_matrix(
            np.array(
                [
                    [-1, 0, 0],
                    [0, 1, 0],
                    [0, 0, 1],
                ]
            )
        )
        self.add(self.right_cone)

        self.title = Text(
            "Tolk", font="Open Sans", weight=BOLD, font_size=self.FONT_SIZE, z_index=10
        )
        self.title.move_to(ORIGIN)
        self.title.shift(DOWN * 0.3)
        self.add(self.title)


class Interpretation(Scene):
    def construct(self):
        compiler = Compiler()
        compiler.to_edge(DOWN)

        lines = Group(*[ImageMobject(f"line{i}.png") for i in range(1, 5)])
        for line in lines.submobjects:
            line.set_width(3)

        lines.arrange(DOWN, buff=0)
        lines.to_edge(UP, buff=1)
        self.add(lines)
        self.add(compiler)
        self.play(FadeIn(lines))

        self.wait(3)

        for line in lines.submobjects:
            self.play(
                line.animate(path_arc=90 * DEGREES).next_to(
                    compiler.left_cone, LEFT, buff=0.3
                )
            )
            self.wait(1)
            self.play(FadeOutToPoint(line, compiler.center_rect.get_center()))
            self.wait(1)

        res = Text("Hello, Marcell!", font="Open Sans", weight=BOLD)
        res.next_to(compiler.right_cone, RIGHT, buff=0.3)
        res.set_z_index(-2)

        self.play(FadeInFromPoint(res, compiler.center_rect.get_center()))
        self.wait(5)
        self.play(FadeOut(res))
