#!/bin/bash
# BudgetJess Auto-Deploy via GitHub → Netlify
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin:$PATH"

REPO="/Users/Jessica/Documents/Claude/Projects/Jessica - finance"
SRC="$REPO/BudgetJess.html"
DEST="$REPO/index.html"
HASH_FILE="/tmp/budgetjess_last_hash"

trap 'exit 0' EXIT INT TERM
sleep 13

[ -f "$SRC" ] || exit 0

# Only deploy if file changed
CURRENT=$(/sbin/md5 -q "$SRC" 2>/dev/null || /usr/bin/md5 -q "$SRC" 2>/dev/null)
LAST=$(cat "$HASH_FILE" 2>/dev/null || echo "")
[ "$CURRENT" = "$LAST" ] && [ -n "$CURRENT" ] && exit 0

# Copy + git push
/bin/cp "$SRC" "$DEST"
cd "$REPO"
/usr/bin/git add index.html
/usr/bin/git commit -m "deploy: auto-update $(date '+%Y-%m-%d %H:%M')" 2>/dev/null || exit 0
/usr/bin/git push origin main 2>/dev/null || /usr/local/bin/git push origin main 2>/dev/null

echo "$CURRENT" > "$HASH_FILE"
echo "[$(date)] pushed to github" >> /tmp/budgetjess_deploy.log
