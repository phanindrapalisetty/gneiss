#!/usr/bin/env bash

set -Eeuo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

GROUP="${1:-all}"

start_group() {
    local group="$1"
    local dir 
    case "$group" in
        infrastructure)
            dir="$INFRA_DIR"
            ;;
        monitoring)
            dir="$MONITORING_DIR"
            ;;
        data-platform)
            dir="$DATA_DIR"
            ;;
        applications)
            dir="$APPLICATIONS_DIR"
            ;;
    esac

    if [[ ! -d "$dir" ]]; then
        echo "[INFO] Skipping '$group' (directory does not exist)"
        return
    fi

    echo ""
    echo "====================================="
    echo "Starting $group"
    echo "====================================="

    find "$dir" -mindepth 2 -maxdepth 2 -name "docker-compose.yml" \
        | sort \
        | while read -r compose; do

        service=$(basename "$(dirname "$compose")")

        echo "→ Starting $service"

        docker compose -f "$compose" up -d

    done
}

case "$GROUP" in
    infrastructure)
        start_group infrastructure
        ;;
    monitoring)
        start_group monitoring
        ;;
    data-platform)
        start_group data-platform
        ;;
    applications)
        start_group applications
        ;;
    all)
        start_group infrastructure
        start_group monitoring
        start_group data-platform
        start_group applications
        ;;
    *)
        echo "Unknown group: $GROUP"
        echo ""
        echo "Usage:"
        echo "  ./up.sh infrastructure"
        echo "  ./up.sh monitoring"
        echo "  ./up.sh data-platform"
        echo "  ./up.sh applications"
        echo "  ./up.sh all"
        exit 1
        ;;
esac

echo ""
echo "✅ Done."