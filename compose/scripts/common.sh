SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

INFRA_DIR="$ROOT/infrastructure"
DATA_DIR="$ROOT/data-platform"
MONITORING_DIR="$ROOT/monitoring"
APPLICATIONS_DIR="$ROOT/applications"