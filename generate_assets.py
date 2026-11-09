import math
import os
from PIL import Image, ImageDraw, ImageFont

BASE_DIR = r"E:\YOUTUBE 2026\Publish APPS\PujaVidhi\pujavidhi_main"
PUBLISH_DIR = os.path.join(BASE_DIR, "publish")
ASSETS_DIR = os.path.join(BASE_DIR, "assets", "icons")

os.makedirs(os.path.join(PUBLISH_DIR, "icons"), exist_ok=True)
os.makedirs(os.path.join(PUBLISH_DIR, "graphics"), exist_ok=True)
os.makedirs(os.path.join(PUBLISH_DIR, "screenshots"), exist_ok=True)
os.makedirs(os.path.join(PUBLISH_DIR, "store_listing"), exist_ok=True)
os.makedirs(ASSETS_DIR, exist_ok=True)

# Colors
MAROON_DARK = (42, 8, 8)
MAROON_MED = (126, 25, 27)
SAFFRON = (230, 81, 0)
GOLD = (255, 193, 7)
LIGHT_GOLD = (255, 236, 179)
WHITE = (255, 255, 255)
FLAME_ORANGE = (255, 112, 67)
FLAME_YELLOW = (255, 238, 88)

def draw_radial_gradient(draw, width, height, center_color, outer_color):
    cx, cy = width / 2, height / 2
    max_radius = math.hypot(cx, cy)
    steps = 60
    for r in range(steps, 0, -1):
        ratio = r / steps
        radius = max_radius * ratio
        # interpolate
        c = tuple(int(outer_color[i] * ratio + center_color[i] * (1 - ratio)) for i in range(3))
        draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=c)

def draw_mandala(draw, cx, cy, radius, color):
    num_petals = 16
    for i in range(num_petals):
        angle = (2 * math.pi / num_petals) * i
        px = cx + radius * math.cos(angle)
        py = cy + radius * math.sin(angle)
        draw.ellipse([px - 14, py - 14, px + 14, py + 14], outline=color, width=2)
    draw.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], outline=color, width=2)
    draw.ellipse([cx - radius + 20, cy - radius + 20, cx + radius - 20, cy + radius - 20], outline=color, width=1)

def draw_diya(draw, cx, cy, scale=1.0):
    # Scale base dimensions
    # Diya bowl
    bowl_w = 120 * scale
    bowl_h = 55 * scale
    draw.chord([cx - bowl_w, cy - 10 * scale, cx + bowl_w, cy + bowl_h * 2], 0, 180, fill=GOLD, outline=LIGHT_GOLD, width=int(3 * scale))
    draw.ellipse([cx - bowl_w, cy - 12 * scale, cx + bowl_w, cy + 18 * scale], fill=(212, 143, 0), outline=LIGHT_GOLD, width=int(2 * scale))
    
    # Sacred oil glow
    draw.ellipse([cx - bowl_w * 0.7, cy - 6 * scale, cx + bowl_w * 0.7, cy + 12 * scale], fill=(180, 100, 0))

    # Diya spout / lip
    spout_pts = [
        (cx - 30 * scale, cy + 2 * scale),
        (cx, cy - 18 * scale),
        (cx + 30 * scale, cy + 2 * scale),
    ]
    draw.polygon(spout_pts, fill=GOLD)

    # Flame outer
    flame_w = 34 * scale
    flame_h = 75 * scale
    flame_top = cy - 25 * scale - flame_h
    
    # Outer flame
    flame_pts = [
        (cx, flame_top),
        (cx + flame_w, cy - 20 * scale),
        (cx, cy - 12 * scale),
        (cx - flame_w, cy - 20 * scale),
    ]
    draw.polygon(flame_pts, fill=FLAME_ORANGE)

    # Inner flame (yellow/white)
    inner_w = 20 * scale
    inner_h = 50 * scale
    inner_top = cy - 22 * scale - inner_h
    inner_pts = [
        (cx, inner_top),
        (cx + inner_w, cy - 18 * scale),
        (cx, cy - 14 * scale),
        (cx - inner_w, cy - 18 * scale),
    ]
    draw.polygon(inner_pts, fill=FLAME_YELLOW)

    # Center bright white core
    core_w = 10 * scale
    core_h = 28 * scale
    core_top = cy - 20 * scale - core_h
    core_pts = [
        (cx, core_top),
        (cx + core_w, cy - 17 * scale),
        (cx, cy - 15 * scale),
        (cx - core_w, cy - 17 * scale),
    ]
    draw.polygon(core_pts, fill=WHITE)

def generate_icons():
    # 512x512 Play Store icon (No alpha)
    img512 = Image.new("RGB", (512, 512), MAROON_DARK)
    d512 = ImageDraw.Draw(img512)
    draw_radial_gradient(d512, 512, 512, MAROON_MED, MAROON_DARK)
    draw_mandala(d512, 256, 256, 170, (255, 193, 7, 120))
    draw_mandala(d512, 256, 256, 130, (255, 236, 179, 100))
    draw_diya(d512, 256, 275, scale=1.4)
    img512.save(os.path.join(PUBLISH_DIR, "icons", "play_store_512.png"))
    img512.save(os.path.join(ASSETS_DIR, "app_icon.png"))

    # 1024x1024 High-res App icon
    img1024 = Image.new("RGBA", (1024, 1024), MAROON_DARK + (255,))
    d1024 = ImageDraw.Draw(img1024)
    draw_radial_gradient(d1024, 1024, 1024, MAROON_MED, MAROON_DARK)
    draw_mandala(d1024, 512, 512, 340, (255, 193, 7))
    draw_mandala(d1024, 512, 512, 260, (255, 236, 179))
    draw_diya(d1024, 512, 550, scale=2.8)
    img1024.save(os.path.join(PUBLISH_DIR, "icons", "app_icon_1024.png"))
    img1024.save(os.path.join(ASSETS_DIR, "splash_logo.png"))
    print("Generated 512 and 1024 icons successfully.")

def generate_feature_graphic():
    # 1024x500 Feature Graphic
    fg = Image.new("RGB", (1024, 500), MAROON_DARK)
    dfg = ImageDraw.Draw(fg)
    draw_radial_gradient(dfg, 1024, 500, MAROON_MED, MAROON_DARK)

    # Decorative Mandalas on left & right
    draw_mandala(dfg, 160, 250, 140, (255, 193, 7))
    draw_mandala(dfg, 864, 250, 140, (255, 193, 7))

    # Center Diya
    draw_diya(dfg, 512, 320, scale=1.5)

    # Text
    try:
        font_title = ImageFont.truetype("arialbd.ttf", 64)
        font_sub = ImageFont.truetype("arial.ttf", 26)
        font_pills = ImageFont.truetype("arialbd.ttf", 20)
    except Exception:
        font_title = font_sub = font_pills = ImageFont.load_default()

    title_text = "PujaVidhi"
    bbox_t = dfg.textbbox((0, 0), title_text, font=font_title)
    tw = bbox_t[2] - bbox_t[0]
    dfg.text(((1024 - tw) / 2, 45), title_text, fill=GOLD, font=font_title)

    sub_text = "Sanatan Vedic Rituals, Panchang & Devotional Suite"
    bbox_s = dfg.textbbox((0, 0), sub_text, font=font_sub)
    sw = bbox_s[2] - bbox_s[0]
    dfg.text(((1024 - sw) / 2, 125), sub_text, fill=LIGHT_GOLD, font=font_sub)

    # Auspicious Feature Badges
    pills = ["Shubh Muhurat", "Step-by-Step Vidhi", "HD Audio Aarti", "108 Japa Mala", "WhatsApp Cards"]
    pill_y = 425
    total_w = 0
    pill_widths = []
    for p in pills:
        b = dfg.textbbox((0, 0), p, font=font_pills)
        pw = b[2] - b[0] + 28
        pill_widths.append(pw)
        total_w += pw + 15
    total_w -= 15

    cur_x = (1024 - total_w) / 2
    for i, p in enumerate(pills):
        pw = pill_widths[i]
        dfg.rounded_rectangle([cur_x, pill_y, cur_x + pw, pill_y + 36], radius=18, fill=(180, 40, 20), outline=GOLD, width=1)
        b = dfg.textbbox((0, 0), p, font=font_pills)
        txt_w = b[2] - b[0]
        dfg.text((cur_x + (pw - txt_w) / 2, pill_y + 8), p, fill=WHITE, font=font_pills)
        cur_x += pw + 15

    fg.save(os.path.join(PUBLISH_DIR, "graphics", "feature_graphic_1024x500.png"))
    print("Generated feature graphic successfully.")

def generate_screenshots():
    screens = [
        ("screenshot_1_panchang_muhurat.png", "Daily Panchang & Shubh Muhurat", "Choghadiya, Rahu Kaal, Tithi & Auspicious Timings", [
            ("Aaj Ka Panchang", "Shukla Paksha • Ekadashi Tithi"),
            ("Shubh Abhijit Muhurat", "11:45 AM - 12:35 PM (Most Auspicious)"),
            ("Rahu Kaal Alert", "04:30 PM - 06:00 PM (Avoid Inauspicious Tasks)"),
            ("Choghadiya Status", "Amrit & Shubh Muhurat Active Now")
        ]),
        ("screenshot_2_puja_vidhi.png", "Vedic Puja Vidhi & Checklist", "Complete Step-by-Step Rituals with Mantras & Samagri", [
            ("Sankalp & Dhyana", "Guided audio initiation with Vedic sankalp"),
            ("Interactive Samagri List", "18/18 items checked: Roli, Akshat, Gangajal"),
            ("Regional Puja Vidhis", "Chhath, Pongal, Durga Puja, Satyanarayan, Shiva Abhishek"),
            ("Dual-Script Mantras", "Recite in Devanagari Sanskrit or English phonetics")
        ]),
        ("screenshot_3_aarti_audio.png", "HD Aarti & Chalisa Player", "Synced Lyrics with Virtual Temple Bell & Shankh", [
            ("Jai Ganesh Deva", "High-Definition Spiritual Audio with Synced Lyrics"),
            ("Hanuman Chalisa", "Chant along with line-by-line highlight"),
            ("Temple Sound Overlay", "Tap virtual Brass Bell & Divine Shankh while playing"),
            ("Offline Mode", "Download once, listen anywhere without internet")
        ]),
        ("screenshot_4_japa_cards.png", "108 Japa Mala & Card Maker", "Sacred Haptic Chanting & WhatsApp Greetings", [
            ("108 Bead Digital Mala", "Realistic haptic vibration & bead click chime"),
            ("Japa History & Streaks", "Track daily rounds, target 11 or 21 malas"),
            ("Custom Festival Cards", "Personalize greetings: 'From: Sharma Family'"),
            ("Instant Social Share", "High-resolution export for WhatsApp & Instagram")
        ])
    ]

    try:
        font_header = ImageFont.truetype("arialbd.ttf", 36)
        font_sub = ImageFont.truetype("arial.ttf", 22)
        font_card_t = ImageFont.truetype("arialbd.ttf", 24)
        font_card_d = ImageFont.truetype("arial.ttf", 18)
    except Exception:
        font_header = font_sub = font_card_t = font_card_d = ImageFont.load_default()

    for filename, title, subtitle, cards in screens:
        img = Image.new("RGB", (720, 1280), MAROON_DARK)
        d = ImageDraw.Draw(img)
        draw_radial_gradient(d, 720, 1280, MAROON_MED, MAROON_DARK)

        # Header bar
        d.rectangle([0, 0, 720, 180], fill=(50, 10, 10))
        d.line([0, 180, 720, 180], fill=GOLD, width=3)
        draw_diya(d, 60, 125, scale=0.6)

        d.text((120, 45), title, fill=GOLD, font=font_header)
        d.text((120, 95), subtitle, fill=LIGHT_GOLD, font=font_sub)

        # Cards
        start_y = 220
        for ct, cd in cards:
            d.rounded_rectangle([40, start_y, 680, start_y + 190], radius=16, fill=(80, 18, 18), outline=(212, 143, 0), width=2)
            # golden ornament circle
            d.ellipse([65, start_y + 35, 105, start_y + 75], fill=GOLD)
            d.ellipse([75, start_y + 45, 95, start_y + 65], fill=(126, 25, 27))

            d.text((125, start_y + 30), ct, fill=WHITE, font=font_card_t)
            d.text((125, start_y + 75), cd, fill=LIGHT_GOLD, font=font_card_d)
            start_y += 220

        # Footer
        d.rectangle([0, 1200, 720, 1280], fill=(30, 6, 6))
        d.line([0, 1200, 720, 1200], fill=GOLD, width=1)
        footer_text = "PujaVidhi • Authentic Vedic Sanatan Suite"
        b_f = d.textbbox((0, 0), footer_text, font=font_sub)
        fw = b_f[2] - b_f[0]
        d.text(((720 - fw) / 2, 1230), footer_text, fill=LIGHT_GOLD, font=font_sub)

        img.save(os.path.join(PUBLISH_DIR, "screenshots", filename))
    print("Generated 4 showcase screenshots successfully.")

if __name__ == "__main__":
    generate_icons()
    generate_feature_graphic()
    generate_screenshots()
