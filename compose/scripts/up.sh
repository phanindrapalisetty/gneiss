#!/usr/bin/env bash

set -Eeuo pipefail

ROOT="${ROOT:-$HOME/Projects/gneiss/compose}"

GROUP="${1:-all}"

start_group() {
    local group="$1"
    local dir="$ROOT/$group"

    if [[ ! -d "$dir" ]]; then
        echo "❌ Group '$group' does not exist."
        exit 1
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