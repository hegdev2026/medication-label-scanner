#!/usr/bin/env python3
"""Builds privacy/index.html from the in-app policy text (assets/translations/en.json)
so the public page and the app never drift apart.

    python3 tool/build_privacy_page.py

Then copy privacy/index.html into the public medscan-privacy repo and push.
"""
import html, json, re, datetime

CONTACT_URL = "https://github.com/hegdev2026/medscan-privacy/issues"
UPDATED = "18 November 2026"  # keep in step with LegalDocuments.lastUpdated

d = json.load(open("assets/translations/en.json", encoding="utf-8"))
L = d["legal"]
p = L["privacy"]
intro = L.get("privacyIntro", "")

sections = []
for i in range(1, 12):
    title = re.sub(r"^\d+\.\s*", "", p[f"s{i}t"])
    sections.append((i, title, p[f"s{i}b"]))

def slug(i, t):
    return f"s{i}-" + re.sub(r"[^a-z0-9]+", "-", t.lower()).strip("-")

toc = "\n".join(
    f'<li><a href="#{slug(i,t)}"><span>{i}</span>{html.escape(t)}</a></li>' for i, t, _ in sections
)
cards = "\n".join(
    f'''<section class="sec" id="{slug(i,t)}" aria-labelledby="h-{i}">
  <div class="num" aria-hidden="true">{i}</div>
  <div class="body"><h2 id="h-{i}">{html.escape(t)}</h2><p>{html.escape(b)}</p></div>
</section>'''
    for i, t, b in sections
)

ICON = {
 "device": '<path d="M7 2h10a2 2 0 0 1 2 2v16a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2zm5 17.5a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>',
 "user": '<path d="M12 12a4.5 4.5 0 1 0 0-9 4.5 4.5 0 0 0 0 9zm0 2c-4.4 0-8 2-8 4.5V21h16v-2.5c0-2.5-3.6-4.5-8-4.5z"/>',
 "scan": '<path d="M4 8V5a1 1 0 0 1 1-1h3v2H6v2H4zm14-4h1a1 1 0 0 1 1 1v3h-2V6h-2V4h2zM4 16h2v2h2v2H5a1 1 0 0 1-1-1v-3zm14 2v-2h2v3a1 1 0 0 1-1 1h-3v-2h2zM7 11h10v2H7z"/>',
 "ad": '<path d="M3 5h18a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V6a1 1 0 0 1 1-1zm3.2 10h1.7l.4-1.2h2.4l.4 1.2h1.7L10.6 8.5H9L6.2 15zm3.1-2.4.8-2.4.8 2.4H9.3zM15 8.5v6.5h1.6V8.5H15z"/>',
}
def card(key, t, s):
    return f'<li class="hl"><svg viewBox="0 0 24 24" aria-hidden="true">{ICON[key]}</svg><div><strong>{t}</strong><span>{s}</span></div></li>'
highlights = "\n".join([
    card("device", "Stays on your device", "Your medicine records are stored only on your phone."),
    card("user", "No account", "No sign-in, no profile, nothing to register."),
    card("scan", "Smart scan is optional", "A photo leaves your phone only if you turn smart scan on."),
    card("ad", "Ads from Google AdMob", "Ads never use your saved medicines."),
])

page = f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>MedScan Privacy Policy</title>
<meta name="description" content="How the MedScan medicine label scanner handles your information.">
<meta name="theme-color" content="#1A4FBF">
<style>
:root{{
  --bg:#F3F8FF;--card:#fff;--fg:#0F1B2D;--muted:#4A5A73;--border:#DCE6F5;
  --primary:#1A4FBF;--primary-soft:#DCE8FF;--hero-a:#123A94;--hero-b:#1A4FBF;--on-hero:#fff;
  --shadow:0 1px 2px rgba(15,27,45,.06),0 8px 24px rgba(15,27,45,.06);
}}
@media (prefers-color-scheme:dark){{:root{{
  --bg:#0B1220;--card:#131D31;--fg:#E3EAF7;--muted:#9FB0CC;--border:#2A3A5A;
  --primary:#9CCBFF;--primary-soft:#1E3A78;--hero-a:#10265C;--hero-b:#1E3A78;--on-hero:#EAF2FF;
  --shadow:0 1px 2px rgba(0,0,0,.4),0 8px 24px rgba(0,0,0,.35);
}}}}
*{{box-sizing:border-box}}
html{{scroll-behavior:smooth;scroll-padding-top:84px}}
@media (prefers-reduced-motion:reduce){{html{{scroll-behavior:auto}}}}
body{{margin:0;background:var(--bg);color:var(--fg);
  font:16px/1.65 system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif;
  -webkit-font-smoothing:antialiased}}
a{{color:var(--primary)}} a:focus-visible,summary:focus-visible{{outline:3px solid var(--primary);outline-offset:3px;border-radius:6px}}
.skip{{position:absolute;left:-999px;top:8px;background:var(--card);padding:8px 12px;border-radius:8px;z-index:20}}
.skip:focus{{left:8px}}
.wrap{{max-width:1040px;margin:0 auto;padding:0 20px}}
header.bar{{position:sticky;top:0;z-index:10;background:color-mix(in srgb,var(--card) 88%,transparent);
  backdrop-filter:saturate(1.4) blur(10px);border-bottom:1px solid var(--border)}}
.bar .wrap{{display:flex;align-items:center;gap:12px;height:60px}}
.logo{{display:grid;place-items:center;width:34px;height:34px;border-radius:10px;
  background:linear-gradient(135deg,var(--hero-a),var(--hero-b));color:#fff}}
.logo svg{{width:20px;height:20px;fill:currentColor}}
.brand{{font-weight:700;letter-spacing:-.01em}}
.tag{{margin-left:auto;font-size:.8rem;color:var(--muted);border:1px solid var(--border);
  padding:4px 10px;border-radius:999px}}
.hero{{background:linear-gradient(135deg,var(--hero-a),var(--hero-b));color:var(--on-hero);
  padding:56px 0 72px}}
.hero h1{{margin:0 0 12px;font-size:clamp(1.9rem,5vw,2.8rem);line-height:1.15;letter-spacing:-.02em}}
.hero p.lead{{margin:0;max-width:640px;font-size:1.1rem;opacity:.92}}
.meta{{display:flex;flex-wrap:wrap;gap:8px;margin-top:22px}}
.chip{{font-size:.82rem;padding:5px 12px;border-radius:999px;background:rgba(255,255,255,.16);
  border:1px solid rgba(255,255,255,.28)}}
.hls{{list-style:none;margin:-40px auto 0;padding:0 20px;max-width:1040px;display:grid;gap:14px;
  grid-template-columns:repeat(auto-fit,minmax(230px,1fr))}}
.hl{{display:flex;gap:14px;align-items:flex-start;background:var(--card);border:1px solid var(--border);
  border-radius:16px;padding:16px;box-shadow:var(--shadow)}}
.hl svg{{flex:none;width:40px;height:40px;padding:9px;border-radius:12px;background:var(--primary-soft);fill:var(--primary)}}
.hl strong{{display:block;line-height:1.3}} .hl span{{display:block;color:var(--muted);font-size:.92rem;margin-top:2px}}
.layout{{display:grid;gap:32px;margin:40px auto 24px;padding:0 20px;max-width:1040px}}
@media(min-width:900px){{.layout{{grid-template-columns:250px 1fr;align-items:start}}}}
nav.toc{{background:var(--card);border:1px solid var(--border);border-radius:16px;padding:14px;box-shadow:var(--shadow)}}
@media(min-width:900px){{nav.toc{{position:sticky;top:80px}}}}
nav.toc summary{{cursor:pointer;font-weight:600;list-style:none;padding:4px 6px}}
nav.toc summary::-webkit-details-marker{{display:none}}
nav.toc ol{{list-style:none;margin:8px 0 0;padding:0}}
nav.toc a{{display:flex;gap:10px;align-items:baseline;padding:7px 8px;border-radius:10px;text-decoration:none;
  color:var(--fg);font-size:.93rem}}
nav.toc a:hover{{background:var(--primary-soft)}}
nav.toc a span{{flex:none;width:22px;text-align:right;color:var(--primary);font-weight:700}}
@media(min-width:900px){{nav.toc details{{pointer-events:none}}nav.toc summary{{pointer-events:none}}}}
.secs{{display:grid;gap:14px}}
.sec{{display:flex;gap:16px;background:var(--card);border:1px solid var(--border);border-radius:16px;
  padding:20px;box-shadow:var(--shadow)}}
.num{{flex:none;display:grid;place-items:center;width:34px;height:34px;border-radius:50%;
  background:var(--primary-soft);color:var(--primary);font-weight:700}}
.sec h2{{margin:2px 0 6px;font-size:1.12rem;letter-spacing:-.01em}}
.sec p{{margin:0;color:var(--muted)}}
.contact{{margin-top:6px;border-radius:16px;padding:22px;color:var(--on-hero);
  background:linear-gradient(135deg,var(--hero-a),var(--hero-b))}}
.contact h2{{margin:0 0 6px;font-size:1.15rem}} .contact p{{margin:0;opacity:.95}}
.contact a{{color:inherit;font-weight:600}}
footer{{max-width:1040px;margin:12px auto 48px;padding:0 20px;color:var(--muted);font-size:.88rem;
  display:flex;flex-wrap:wrap;gap:8px 20px;justify-content:space-between}}
@media print{{header.bar,nav.toc,.hls{{display:none}}.hero{{background:none;color:#000;padding:0}}
  .sec,.hl{{box-shadow:none;break-inside:avoid}}body{{background:#fff}}}}
</style>
</head>
<body>
<a class="skip" href="#content">Skip to content</a>
<header class="bar"><div class="wrap">
  <span class="logo"><svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2 4 5v6c0 5 3.4 9.4 8 11 4.6-1.6 8-6 8-11V5l-8-3zm1 14h-2v-3H8v-2h3V8h2v3h3v2h-3v3z"/></svg></span>
  <span class="brand">MedScan</span>
  <span class="tag">Privacy Policy</span>
</div></header>

<section class="hero"><div class="wrap">
  <h1>Your privacy, in plain words</h1>
  <p class="lead">{html.escape(intro)}</p>
  <div class="meta"><span class="chip">Last updated {UPDATED}</span><span class="chip">Applies to the MedScan Android app</span></div>
</div></section>

<ul class="hls" aria-label="Privacy at a glance">
{highlights}
</ul>

<main id="content" class="layout">
  <nav class="toc" aria-label="Contents"><details open><summary>Contents</summary><ol>
{toc}
  </ol></details></nav>
  <div>
    <div class="secs">
{cards}
    </div>
    <div class="contact" role="note" style="margin-top:14px">
      <h2>Questions about this policy?</h2>
      <p>Open an issue at <a href="{CONTACT_URL}">{CONTACT_URL.replace("https://","")}</a> and we will get back to you.</p>
    </div>
  </div>
</main>

<footer>
  <span>MedScan helps you keep track of medicine labels and expiry dates. It is not medical advice.</span>
  <a href="#top" onclick="window.scrollTo(0,0);return false">Back to top ↑</a>
</footer>
</body>
</html>
"""
open("privacy/index.html", "w", encoding="utf-8").write(page)
print("wrote privacy/index.html", len(page), "bytes")
