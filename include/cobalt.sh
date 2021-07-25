# goto project root (default: current) or home
gg() { cd "${1:-$(git rev-parse --show-toplevel 2>/dev/null || echo ~)}"; }
g_complete() {

}
