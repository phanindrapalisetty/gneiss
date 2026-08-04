#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="${ROOT:-$HOME/Projects/gneiss/compose}"

GROUP="${1:-all}"

stop_group() {
    local group="$1"
    local dir="$ROOT/$group"

    if [[ ! -d "$dir" ]]; then
        echo "❌ Group '$group' does not exist."
        exit 1
    fi

    echo ""
    echo "====================================="
    echo "Stopping $group"
    echo "====================================="

    find "$dir" -mindepth 2 -maxdepth 2 -name "docker-compose.yml" \
        | sort -r \
        | while read -r compose; do

        service=$(basename "$(dirname "$compose")")

        echo "→ Stopping $service"

        docker compose -f "$compose" down

    done
}

case "$GROUP" in
    infrastructure)
        stop_group infrastructure
        ;;
    monitoring)
        stop_group monitoring
        ;;
    data-platform)
        stop_group data-platform
        ;;
    applications)
        stop_group applications
        ;;
    all)
        # Stop in reverse dependency order
        stop_group applications
        stop_group monitoring
        stop_group data-platform
        stop_group infrastructure
        ;;
    *)
        echo "Unknown group: $GROUP"
        echo ""
        echo "Usage:"
        echo "  ./down.sh infrastructure"
        echo "  ./down.sh monitoring"
        echo "  ./down.sh data-platform"
        echo "  ./down.sh applications"
        echo "  ./down.sh all"
        exit 1
        ;;
esac

echo ""
echo "✅ Done."