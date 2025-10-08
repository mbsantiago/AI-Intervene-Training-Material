import datetime
from pathlib import Path

import colab_utils
import ipywidgets as widgets
import numpy as np
from PIL import Image


def show_image_grid(
    paths,
    n_cols: int = 3,
    n_rows: int = 6,
    width: int = 600,
    height: int = 400,
    format: str = "jpeg",
):
    images = []

    for _, path in zip(range(n_cols * n_rows), paths):
        with open(path, "rb") as fp:
            images.append(
                widgets.Image(
                    value=fp.read(),
                    format=format,
                    width=width,
                    height=height,
                )
            )

    return widgets.GridBox(
        children=images,
        layout=widgets.Layout(
            grid_template_columns=" ".join([f"{width}px"] * n_cols), grid_gap="5px 10px"
        ),
    )


def image_tabs(
    paths,
    width: int = 1000,
    height: int = 600,
    format: str = "jpeg",
    show_max: int = 20,
    image_dir: Path | None = None,
):
    images = []

    if len(paths) > show_max:
        paths = paths[:show_max]

    for path in paths:
        if image_dir is not None:
            path = image_dir / path

        with open(path, "rb") as fp:
            images.append(
                widgets.Image(
                    value=fp.read(),
                    format=format,
                    width=width,
                    height=height,
                )
            )

    tab = widgets.Tab()
    tab.children = images
    for i in range(len(images)):
        tab.set_title(i, str(i))

    slider = widgets.IntSlider(
        value=0,
        min=0,
        max=len(images) - 1,
        step=1,
        description="Image",
        disabled=False,
        continuous_update=True,
        orientation="horizontal",
        readout=True,
        readout_format="d",
    )

    play = widgets.Play(
        interval=2000,
        value=0,
        min=0,
        max=len(images) - 1,
        step=1,
        description="Press play",
        disabled=False,
        playing=True,
    )
    play.playing = True

    widgets.jslink((slider, "value"), (tab, "selected_index"))
    widgets.jslink((play, "value"), (slider, "value"))
    return widgets.VBox([widgets.HBox([play, slider]), tab])


class Annotator:
    def __init__(
        self,
        images: list[Path],
        width: int = 1000,
        height: int = 600,
    ):
        self.images = images

        self._start_time = None
        self._stop_time = None

        self._image_arrays = [
            np.array(Image.open(path).resize((width, height))) for path in images
        ]

        self._bboxes = []

    def start(self):
        self._start_time = datetime.datetime.now()

        return colab_utils.annotate(
            self._image_arrays,  # type: ignore
            box_storage_pointer=self._bboxes,
            callback=self.stop,
        )

    def stop(self):
        if self._start_time is None:
            raise RuntimeError("Annotator has not started.")

        self._stop_time = datetime.datetime.now()

    @property
    def annotations(self):
        if self._start_time is None:
            raise ValueError("Annotation has not started")

        if self._stop_time is None:
            raise ValueError("Annotation has not ended")

        return [
            np.array(bboxes, dtype=np.float32)
            for bboxes in self._bboxes
            if bboxes is not None
        ]

    @property
    def duration(self):
        if self._start_time is None:
            raise ValueError("Annotation has not started")

        if self._stop_time is None:
            raise ValueError("Annotation has not ended")

        return self._stop_time - self._start_time