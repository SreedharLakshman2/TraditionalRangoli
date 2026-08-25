#!/usr/bin/env python3
"""Canva-style Traditional Rangoli posters: 3D courtyard fields, titanium iPhone Pro / iPad Pro, gradient titles."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent
RAW = ROOT / "raw"
BG = ROOT / "backgrounds"

AVENIR = "/System/Library/Fonts/Avenir Next.ttc"
HELVETICA = "/System/Library/Fonts/HelveticaNeue.ttc"
ROUNDED = "/System/Library/Fonts/SFNSRounded.ttf"

WHITE = (255, 255, 255)
IVORY = (255, 248, 238)
GOLD = (232, 197, 107)
GOLD_DEEP = (200, 155, 60)
MAROON = (155, 44, 44)
TERRACOTTA = (196, 92, 42)
LEAF = (92, 138, 100)

POSTERS = [
    {
        "file": "01-discover.png",
        "capture": "01-home.png",
        "bg": "bg-01-discover.png",
        "kicker": "DISCOVER",
        "title": ("The courtyard", "is waiting"),
        "sub": "Daily lotus, pulli, and festival floors.",
        "title_colors": [WHITE, IVORY, GOLD],
        "sub_color": (255, 232, 210),
        "glow": GOLD_DEEP,
        "bias": 0.62,
    },
    {
        "file": "02-learn.png",
        "capture": "02-learn.png",
        "bg": "bg-02-learn.png",
        "kicker": "LEARN",
        "title": ("Trace it", "stroke by stroke"),
        "sub": "Kind guided lessons on a pulli grid.",
        "title_colors": [WHITE, GOLD, MAROON],
        "sub_color": (255, 236, 214),
        "glow": MAROON,
        "bias": 0.45,
    },
    {
        "file": "03-trace.png",
        "capture": "03-studio.png",
        "bg": "bg-03-trace.png",
        "kicker": "TRACE",
        "title": ("One line", "becomes eight"),
        "sub": "Symmetry that mirrors a powder stroke.",
        "title_colors": [WHITE, GOLD, TERRACOTTA],
        "sub_color": (255, 226, 186),
        "glow": TERRACOTTA,
        "bias": 0.50,
    },
    {
        "file": "04-create.png",
        "capture": "04-create.png",
        "bg": "bg-04-create.png",
        "kicker": "CREATE",
        "title": ("Dot, freehand,", "template"),
        "sub": "Three ways to lay rice powder.",
        "title_colors": [WHITE, IVORY, GOLD],
        "sub_color": (255, 240, 214),
        "glow": GOLD_DEEP,
        "bias": 0.38,
    },
    {
        "file": "05-decorate.png",
        "capture": "05-color.png",
        "bg": "bg-05-decorate.png",
        "kicker": "DECORATE",
        "title": ("Rice, flowers,", "and diyas"),
        "sub": "Color the courtyard you just drew.",
        "title_colors": [WHITE, GOLD, (255, 170, 80)],
        "sub_color": (255, 236, 200),
        "glow": (210, 120, 40),
        "bias": 0.55,
    },
    {
        "file": "06-save.png",
        "capture": "06-saved.png",
        "bg": "bg-06-save.png",
        "kicker": "SAVE",
        "title": ("Keep the floor", "you drew"),
        "sub": "Gallery on this iPhone or iPad. No account.",
        "title_colors": [WHITE, IVORY, GOLD],
        "sub_color": (255, 230, 200),
        "glow": LEAF,
        "bias": 0.42,
    },
]

SIZES = {
    "iphone-6.9": (1320, 2868),
    "ipad-13": (2064, 2752),
}


def font(path: str, size: int, index: int = 0) -> ImageFont.FreeTypeFont:
    return ImageFont.truetype(path, size, index=index)


def display(size: int) -> ImageFont.FreeTypeFont:
    return font(AVENIR, size, 8)


def subtitle_font(size: int) -> ImageFont.FreeTypeFont:
    return font(AVENIR, size, 5)


def ui_bold(size: int) -> ImageFont.FreeTypeFont:
    try:
        return font(ROUNDED, size)
    except OSError:
        return font(AVENIR, size, 0)


def brand_font(size: int) -> ImageFont.FreeTypeFont:
    return font(HELVETICA, size, 10)


def lerp(a: tuple[int, int, int], b: tuple[int, int, int], t: float) -> tuple[int, int, int]:
    t = max(0.0, min(1.0, t))
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def lerp_stops(colors: list[tuple[int, int, int]], t: float) -> tuple[int, int, int]:
    if len(colors) == 1:
        return colors[0]
    t = max(0.0, min(1.0, t))
    scaled = t * (len(colors) - 1)
    i = min(int(scaled), len(colors) - 2)
    return lerp(colors[i], colors[i + 1], scaled - i)


def cover(im: Image.Image, size: tuple[int, int], bias_y: float = 0.42) -> Image.Image:
    tw, th = size
    sw, sh = im.size
    scale = max(tw / sw, th / sh)
    nw, nh = max(1, int(sw * scale + 0.5)), max(1, int(sh * scale + 0.5))
    resized = im.convert("RGB").resize((nw, nh), Image.Resampling.LANCZOS)
    left = (nw - tw) // 2
    top = max(0, min(nh - th, int((nh - th) * bias_y)))
    return resized.crop((left, top, left + tw, top + th))


def rounded(im: Image.Image, radius: int) -> Image.Image:
    out = im.convert("RGBA")
    mask = Image.new("L", out.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, out.size[0] - 1, out.size[1] - 1), radius, fill=255)
    out.putalpha(mask)
    return out


def fit_display(text: str, target: int, max_width: int) -> ImageFont.FreeTypeFont:
    size = target
    while size >= 36:
        face = display(size)
        if face.getlength(text) <= max_width:
            return face
        size -= 4
    return display(36)


def titanium_shell(size: tuple[int, int], radius: int, dark: bool = False) -> Image.Image:
    w, h = size
    strip = Image.new("RGB", (w, 1))
    sp = strip.load()
    light = ((246, 242, 236), (214, 208, 200), (148, 142, 134))
    space = ((72, 70, 68), (48, 46, 44), (28, 27, 26))
    a, b, c = space if dark else light
    for x in range(w):
        t = x / max(w - 1, 1)
        if t < 0.18:
            sp[x, 0] = lerp(a, b, t / 0.18)
        elif t > 0.82:
            sp[x, 0] = lerp(b, c, (t - 0.82) / 0.18)
        else:
            sp[x, 0] = b
    shell = strip.resize((w, h), Image.Resampling.BILINEAR).convert("RGBA")
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, w - 1, h - 1), radius, fill=255)
    shell.putalpha(mask)
    shine = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    ImageDraw.Draw(shine).rectangle((2, 2, max(3, w // 18), h - 3), fill=(255, 255, 255, 46))
    shine.putalpha(Image.composite(shine.split()[-1], Image.new("L", (w, h), 0), mask))
    shell.alpha_composite(shine)
    return shell


def iphone_pro(screen: Image.Image) -> Image.Image:
    sw, sh = screen.size
    metal = max(11, sw // 38)
    lip = max(4, sw // 80)
    rim = metal + lip
    fw, fh = sw + 2 * rim, sh + 2 * rim
    btn = max(7, rim + 2)
    pad_x, pad_t, pad_b = btn + 10, 8, 40
    canvas = Image.new("RGBA", (fw + pad_x * 2, fh + pad_t + pad_b), (0, 0, 0, 0))
    ox, oy = pad_x, pad_t
    outer_r = int(sw * 0.145)
    screen_r = max(30, outer_r - rim)

    canvas.alpha_composite(titanium_shell((fw, fh), outer_r), (ox, oy))
    inner = rounded(Image.new("RGBA", (fw - metal * 2, fh - metal * 2), (8, 8, 10, 255)), max(12, outer_r - metal))
    canvas.alpha_composite(inner, (ox + metal, oy + metal))
    canvas.alpha_composite(rounded(screen.convert("RGB"), screen_r), (ox + rim, oy + rim))

    d = ImageDraw.Draw(canvas)
    metal_fill = (198, 193, 186)
    d.rounded_rectangle((ox - btn + 3, oy + int(fh * 0.155), ox + 3, oy + int(fh * 0.20)), 3, fill=metal_fill)
    d.rounded_rectangle((ox - btn + 3, oy + int(fh * 0.235), ox + 3, oy + int(fh * 0.325)), 3, fill=metal_fill)
    d.rounded_rectangle((ox - btn + 3, oy + int(fh * 0.345), ox + 3, oy + int(fh * 0.435)), 3, fill=metal_fill)
    d.rounded_rectangle((ox + fw - 3, oy + int(fh * 0.27), ox + fw + btn - 3, oy + int(fh * 0.40)), 3, fill=metal_fill)
    return canvas


def ipad_pro(screen: Image.Image) -> Image.Image:
    sw, sh = screen.size
    metal = max(10, sw // 70)
    lip = max(4, sw // 120)
    rim = metal + lip
    fw, fh = sw + 2 * rim, sh + 2 * rim
    pad = 28
    canvas = Image.new("RGBA", (fw + pad * 2, fh + pad * 2), (0, 0, 0, 0))
    ox, oy = pad, pad
    outer_r = int(min(sw, sh) * 0.055)
    screen_r = max(18, outer_r - rim)
    canvas.alpha_composite(titanium_shell((fw, fh), outer_r, dark=True), (ox, oy))
    inner = rounded(Image.new("RGBA", (fw - metal * 2, fh - metal * 2), (10, 10, 12, 255)), max(10, outer_r - metal))
    canvas.alpha_composite(inner, (ox + metal, oy + metal))
    canvas.alpha_composite(rounded(screen.convert("RGB"), screen_r), (ox + rim, oy + rim))
    d = ImageDraw.Draw(canvas)
    cam = max(7, sw // 90)
    cx = ox + fw // 2
    cy = oy + rim // 2 + metal // 2
    d.ellipse((cx - cam, cy - cam, cx + cam, cy + cam), fill=(20, 22, 26))
    d.ellipse((cx - cam + 3, cy - cam + 3, cx + cam - 3, cy + cam - 3), fill=(40, 48, 64))
    return canvas


def glass_chip(text: str, width_hint: int, accent: tuple[int, int, int]) -> Image.Image:
    face = ui_bold(max(16, width_hint))
    pad_x, pad_y = 28, 12
    tw = int(face.getlength(text))
    w, h = tw + pad_x * 2, int(face.size + pad_y * 2)
    chip = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    d = ImageDraw.Draw(chip)
    d.rounded_rectangle((0, 0, w - 1, h - 1), h // 2, fill=(255, 255, 255, 42), outline=accent + (200,), width=2)
    d.text((w / 2, h / 2), text, font=face, fill=WHITE, anchor="mm")
    return chip


def stacked_title(lines: tuple[str, ...], colors: list[tuple[int, int, int]], max_width: int, target: int) -> Image.Image:
    faces = [fit_display(line, target, max_width) for line in lines]
    probe = ImageDraw.Draw(Image.new("L", (8, 8)))
    sizes = []
    for line, face in zip(lines, faces):
        x0, y0, x1, y1 = probe.textbbox((0, 0), line, font=face)
        sizes.append((x0, y0, max(1, x1 - x0), max(1, y1 - y0), face, line))
    gap = int(target * 0.06)
    pad = 16
    width = max(s[2] for s in sizes) + pad * 2
    height = sum(s[3] for s in sizes) + gap * (len(sizes) - 1) + pad * 2
    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)
    y = pad
    for x0, y0, w, h, face, line in sizes:
        draw.text(((width - w) // 2 - x0, y - y0), line, font=face, fill=255)
        y += h + gap
    grad = Image.new("RGB", mask.size)
    px = grad.load()
    mh = mask.size[1]
    for yy in range(mh):
        c = lerp_stops(colors, yy / max(mh - 1, 1))
        for xx in range(mask.size[0]):
            px[xx, yy] = c
    ink = Image.new("RGBA", mask.size, (0, 0, 0, 0))
    ink.paste(grad, (0, 0), mask)
    glow = Image.new("RGBA", mask.size, (0, 0, 0, 0))
    glow.paste((*colors[-1], 140), (0, 0), mask)
    glow = glow.filter(ImageFilter.GaussianBlur(12))
    shadow = Image.new("RGBA", mask.size, (0, 0, 0, 0))
    shadow.paste((40, 16, 20, 150), (0, 0), mask)
    shadow = shadow.filter(ImageFilter.GaussianBlur(8))
    layered = Image.new("RGBA", (width + 24, height + 24), (0, 0, 0, 0))
    layered.alpha_composite(glow, (12, 14))
    layered.alpha_composite(shadow, (14, 16))
    layered.alpha_composite(ink, (12, 8))
    return layered


def load_capture(spec: dict, folder: str) -> Image.Image:
    named = RAW / folder / spec["capture"]
    if named.exists():
        return Image.open(named).convert("RGB")
    fallback = RAW / "iphone" / spec["capture"]
    if fallback.exists():
        return Image.open(fallback).convert("RGB")
    raise FileNotFoundError(f"Missing capture {spec['capture']} for {folder}")


def compose(spec: dict, canvas_size: tuple[int, int], folder: str) -> Image.Image:
    W, H = canvas_size
    phone = W < 1600
    canvas = cover(Image.open(BG / spec["bg"]), canvas_size, spec["bias"]).convert("RGBA")

    top = Image.new("RGBA", (W, int(H * 0.34)), (0, 0, 0, 0))
    ImageDraw.Draw(top).rectangle((0, 0, W, top.size[1]), fill=(28, 12, 10, 88))
    canvas.alpha_composite(top.filter(ImageFilter.GaussianBlur(32)), (0, 0))

    pad = int(W * (0.07 if phone else 0.08))
    y = int(H * (0.032 if phone else 0.036))
    chip = glass_chip(spec["kicker"], int(W * 0.026), spec["glow"])
    canvas.alpha_composite(chip, ((W - chip.width) // 2, y))
    y += chip.height + int(H * 0.008)

    title = stacked_title(
        spec["title"],
        spec["title_colors"],
        W - pad * 2,
        int(min(W * (0.118 if phone else 0.078), H * 0.054)),
    )
    canvas.alpha_composite(title, ((W - title.width) // 2, y - 8))
    y += title.height - int(H * 0.01)

    sub_face = subtitle_font(int(min(W * (0.034 if phone else 0.026), H * 0.018)))
    ImageDraw.Draw(canvas).text((W / 2, y + 4), spec["sub"], font=sub_face, fill=spec["sub_color"] + (255,), anchor="mt")
    header_bottom = y + int(H * 0.028)

    shot = load_capture(spec, "iphone" if phone else "ipad")
    footer_h = int(H * 0.055)
    avail_h = H - header_bottom - footer_h
    target_h = int(avail_h * 0.98)
    if phone:
        inner_h = target_h
        inner_w = int(inner_h * 19.5 / 42.3)
        max_w = int(W * 0.80)
        if inner_w > max_w:
            inner_w = max_w
            inner_h = int(inner_w * 42.3 / 19.5)
        screen = shot.resize((inner_w, inner_h), Image.Resampling.LANCZOS)
        framed = iphone_pro(screen)
    else:
        inner_w = int(W * 0.78)
        inner_h = int(inner_w * shot.height / max(shot.width, 1))
        if inner_h > target_h:
            inner_h = target_h
            inner_w = int(inner_h * shot.width / max(shot.height, 1))
        screen = shot.resize((inner_w, inner_h), Image.Resampling.LANCZOS)
        framed = ipad_pro(screen)

    px = (W - framed.width) // 2
    py = header_bottom + max(0, (avail_h - framed.height) // 2)

    glow = Image.new("RGBA", (framed.width + 160, framed.height + 160), (0, 0, 0, 0))
    ImageDraw.Draw(glow).rounded_rectangle(
        (40, 50, 120 + framed.width, 90 + framed.height),
        radius=int(framed.width * 0.12),
        fill=spec["glow"] + (80,),
    )
    glow = glow.filter(ImageFilter.GaussianBlur(38))
    shadow = Image.new("RGBA", (framed.width + 100, framed.height + 100), (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (20, 28, 20 + framed.width, 36 + framed.height),
        radius=int(framed.width * 0.10),
        fill=(0, 0, 0, 160),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(26))
    canvas.alpha_composite(glow, (px - 80, py - 60))
    canvas.alpha_composite(shadow, (px - 20, py - 8))
    canvas.alpha_composite(framed, (px, py))

    foot = brand_font(max(18, int(W * 0.022)))
    ImageDraw.Draw(canvas).text(
        (W / 2, H - int(H * 0.028)),
        "Traditional Rangoli   ·   Sai Laksha Technologies",
        font=foot,
        fill=(255, 255, 255, 230),
        anchor="ms",
    )
    return canvas.convert("RGB")


def main() -> None:
    for folder, size in SIZES.items():
        out = ROOT / folder
        out.mkdir(parents=True, exist_ok=True)
        for spec in POSTERS:
            img = compose(spec, size, folder)
            dest = out / spec["file"]
            img.save(dest, "PNG", optimize=True)
            print(dest.relative_to(ROOT.parent.parent), img.size)


if __name__ == "__main__":
    main()
