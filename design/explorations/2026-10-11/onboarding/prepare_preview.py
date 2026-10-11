"""Bundle the editable onboarding concept for an offline inline preview."""
from pathlib import Path
import base64
import json
import sys

from fontTools import subset
from fontTools.ttLib import TTFont

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
OUTPUT = Path(sys.argv[1]) if len(sys.argv) > 1 else ROOT / "build/onboarding-preview/foodjury-onboarding.html"
BUILD = ROOT / "build/onboarding-preview"
BUILD.mkdir(parents=True, exist_ok=True)


def data_uri(path: Path, mime: str) -> str:
    return f"data:{mime};base64," + base64.b64encode(path.read_bytes()).decode()


source = (HERE / "prototype.html").read_text()
for placeholder, filename in (("__FONT_BANGERS__", "Bangers-Regular.ttf"), ("__FONT_NUNITO__", "Nunito-Variable.ttf")):
    font = TTFont(ROOT / "assets/fonts" / filename)
    options = subset.Options()
    options.flavor = "woff2"
    options.layout_features = ["*"]
    reducer = subset.Subsetter(options=options)
    reducer.populate(text=source + "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789“”‘’…✓→‹★○")
    reducer.subset(font)
    font.flavor = "woff2"
    output_font = BUILD / filename.replace(".ttf", ".woff2")
    font.save(output_font)
    source = source.replace(placeholder, data_uri(output_font, "font/woff2"))

assets = {path.stem: data_uri(path, "image/webp") for path in sorted((HERE / "assets").glob("*.webp"))}
source = source.replace("__ASSET_DATA__", json.dumps(assets, separators=(",", ":")))
assert "__FONT_" not in source and "__ASSET_DATA__" not in source
assert len(source.encode()) < 1_000_000, "Inline preview exceeds the 1 MB contract"
OUTPUT.parent.mkdir(parents=True, exist_ok=True)
OUTPUT.write_text(source)
print(f"Bundled {len(assets)} images. {OUTPUT} ({len(source.encode()):,} bytes)")
