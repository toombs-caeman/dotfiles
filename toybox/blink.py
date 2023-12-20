#!/bin/env python
import wx
from itertools import cycle, repeat, chain
# the idea: https://news.ycombinator.com/item?id=38276107

# linear-ish tween between integers
def itween(start, stop, step_count):
    r = (stop - start) / step_count
    yield int(start)
    for _ in range(step_count):
        start += r
        yield int(start)

# animate a value with an iterable of values to assign
class Anim(wx.Timer):
    def __init__(self, setter, val_iter, callback=None):
        super().__init__()
        self.setter = setter
        self.val_iter = iter(val_iter)
        self.callback = callback
    def Notify(self):
        try:
            self.setter(next(self.val_iter))
        except StopIteration:
            self.Stop()
            if self.callback:
                self.callback()

class MyApp(wx.App):
    def OnInit(self):
        frame = wx.Frame(None, -1, 'i3termlauncher')
        frame.SetBackgroundColour('black')
        frame.SetTransparent(255)
        frame.Show(True)

        # move from fully opaque to fully transparent over 20 minutes
        # close the window when done
        self.transparent = Anim(frame.SetTransparent, itween(255, 0, 20 * 60), frame.Close)
        self.transparent.Start(1000)

        # cycle the colors between red and black, while slowly increasing
        # the delay between blinks over the course of ~7 minutes
        delays = chain(itween(400, 1000, 600), repeat(1000))
        colors = cycle(['red', 'black'])
        data = zip(delays, colors)
        def slowingblink(data): 
            delay, color = data
            frame.SetBackgroundColour(color)
            self.blink.StartOnce(delay)
        self.blink = Anim(slowingblink, data)
        self.blink.StartOnce(next(delays))
        return True

app = MyApp(0)
app.MainLoop()
