"""Index the exact same-origin files shipped by a Flutter web build."""

import hashlib
import json
from pathlib import Path
from urllib.parse import quote

root = Path(__file__).resolve().parent.parent / "build" / "web"
manifest = root / "offline-manifest.js"
required = (
    "index.html",
    "main.dart.js",
    "flutter_bootstrap.js",
    "offline-worker.js",
    "offline-status.js",
    "manifest.json",
    "assets/assets/images/biology/zati.png",
)
missing = [name for name in required if not (root / name).is_file()]
if missing:
    raise SystemExit(f"Missing web build files: {', '.join(missing)}")
files = sorted(
    path for path in root.rglob("*")
    if path.is_file() and path != manifest and path.suffix != ".map"
    # Many hosts do not serve hidden files such as .last_build_id.
    and not any(part.startswith(".") for part in path.relative_to(root).parts)
)
version = hashlib.sha256()
urls = []
for path in files:
    name = path.relative_to(root).as_posix()
    urls.append(quote(name))
    version.update(name.encode())
    version.update(hashlib.sha256(path.read_bytes()).digest())
temporary = manifest.with_suffix(".tmp")
temporary.write_text(
    f"self.exploraOffline = {json.dumps({'version': version.hexdigest(), 'files': urls, 'required': list(required)})};\n",
    encoding="utf-8",
)
temporary.replace(manifest)
print(f"Indexed {len(files)} files for offline use.")
