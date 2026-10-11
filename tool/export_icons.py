"""Export approved launcher artwork with macOS sips (no creative image edits)."""
from pathlib import Path
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / 'assets/images/brand/app-icon-master.png'
IOS = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'

def export(size, destination):
    destination.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(['sips', '-z', str(size), str(size), str(MASTER), '--out', str(destination)], check=True, capture_output=True)

export(1024, IOS / 'AppIcon.png')
(IOS / 'Contents.json').write_text(json.dumps({
    'images': [{'filename': 'AppIcon.png', 'idiom': 'universal', 'platform': 'ios', 'size': '1024x1024'}],
    'info': {'author': 'xcode', 'version': 1}
}, indent=2) + '\n')
for density, size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    export(size, ROOT / f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
print('Exported iOS universal icon and five Android launcher densities.')
