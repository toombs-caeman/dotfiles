import colorsys
import functools

import numpy as np
from scipy.spatial import KDTree
from PIL import Image

solarized = [ '073642', 'dc322f', '859900', 'b58900',
              '268bd2', 'd33682', '2aa198', 'eee8d5',
              '002b36', 'cb4b16', '586e75', '657b83',
              '839496', '6c71c4', '93a1a1', 'fdf6e3' ]
color_names = [
    'black', 'red', 'green', 'yellow',
    'blue', 'magenta', 'cyan', 'lgray',
    'gray', 'lred', 'lgreen', 'lyellow',
    'lblue', 'lmagenta', 'lcyan', 'white',
]

def str_to_rgb(s):
    return np.array([int(x+y, 16) for x, y in zip(*[iter(s)]*2)])

def rgb_to_str(v):
    return '%02x%02x%02x' % tuple(map(int, (v * 256 / np.linalg.norm(v))))

def rgb_to_hsv(v):
        return np.array(colorsys.rgb_to_hsv(*v))



def background_to_scheme(filename):
    if filename is None:
        return {k:v for k, v in zip(color_names, solarized)}

    # generate a scatter plot from the given file
    img = Image.open(filename)
    if img.mode != 'RGB':
        img = img.convert('RGB')
    ncolors = 256
    scatter = sorted(
        img.convert('P', palette=Image.ADAPTIVE, colors=ncolors).convert('RGB').getcolors(ncolors),
        reverse=True,
    )
    def resize(scatter):
        for norm, angle in scatter:
            angle = np.array(angle)
            yield angle * norm / np.linalg.norm(angle)
    scatter = np.array(list(resize(scatter)))
    scatter /= max(*map(np.linalg.norm,scatter))

    # create the default template from solarized
    original = default = np.array(list(map(str_to_rgb, solarized)))
    default = default / np.linalg.norm(default)
    tree = KDTree(default) # nearest neighbors
    trans_map = {tuple(v): [] for v in default}
    for v in scatter:
        dist, loc = tree.query(v)
        trans_map[tuple(default[loc])].append(v)

    scheme = {
        # force the value back to default levels
        name: np.array(colorsys.hsv_to_rgb(
            *colorsys.rgb_to_hsv(*computed)[:2],
            colorsys.rgb_to_hsv(*original)[2]),
        )
        for name, original, computed in zip(
            color_names,
            original,
            iter(
                # average all nearest neighbors, use the default if there aren't any
                np.average(trans_map[tuple(v)], axis=0) if trans_map[tuple(v)] else v
                for v in default
            ),
        )
    }

    # convert to strings and return
    return {k: rgb_to_str(v) for k, v in scheme.items()}

if __name__ == "__main__":
    print(background_to_scheme('/home/ubernormal/Pictures/Wallpapers/4RXcHTr.jpg'))

