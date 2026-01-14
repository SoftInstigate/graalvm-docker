#!/bin/bash
set -e

# Multi-architecture Docker build script for GraalVM images
# Builds for linux/amd64 and linux/arm64

REGISTRY="${REGISTRY:-softinstigate/graalvm}"
VERSION="${VERSION:-25}"
PLATFORMS="linux/amd64,linux/arm64"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         Multi-Architecture GraalVM Docker Build              ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Registry: ${REGISTRY}"
echo "Version:  ${VERSION}"
echo "Platforms: ${PLATFORMS}"
echo ""

# Check if buildx is available
if ! docker buildx version > /dev/null 2>&1; then
    echo "❌ Error: docker buildx is not available"
    echo "Please install Docker Desktop or enable buildx"
    exit 1
fi

# Create buildx builder if it doesn't exist
if ! docker buildx inspect multiarch > /dev/null 2>&1; then
    echo "Creating buildx builder 'multiarch'..."
    docker buildx create --name multiarch --driver docker-container --use
    docker buildx inspect --bootstrap
fi

# Use the multiarch builder
docker buildx use multiarch

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "Building images..."
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Function to build and push an image
build_image() {
    local dockerfile=$1
    local tag_suffix=$2
    local description=$3
    
    echo "→ Building: ${REGISTRY}:${VERSION}${tag_suffix}"
    echo "  File: ${dockerfile}"
    echo "  Description: ${description}"
    echo ""
    
    docker buildx build \
        --platform "${PLATFORMS}" \
        --file "${dockerfile}" \
        --tag "${REGISTRY}:${VERSION}${tag_suffix}" \
        --tag "${REGISTRY}:latest${tag_suffix}" \
        --push \
        .
    
    echo "✅ Successfully built: ${REGISTRY}:${VERSION}${tag_suffix}"
    echo ""
}

# Build distroless (default)
build_image "Dockerfile.distroless" "" "Distroless, maximum security (default)"

# Build shell variant
build_image "Dockerfile" "-shell" "With shell for debugging"

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║                    Build Complete!                            ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "Images built for: ${PLATFORMS}"
echo ""
echo "Available images:"
echo "  ${REGISTRY}:${VERSION}            (285MB - distroless, default)"
echo "  ${REGISTRY}:${VERSION}-shell      (365MB - with shell)"
echo ""
echo "To inspect manifest:"
echo "  docker buildx imagetools inspect ${REGISTRY}:${VERSION}"
echo ""
