#!/bin/bash
# Usage: ./deploy/generate-company-instance.sh <company-name>
#
# Generates a standalone company deployment — a self-contained repo the company
# can run with Claude Code independently.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <company-name>"
    echo ""
    echo "Example: $0 acme"
    echo ""
    echo "Prerequisites:"
    echo "  - companies/<company>/COMPANY.md must exist"
    exit 1
fi

COMPANY="$1"
COMPANY_SLUG=$(echo "$COMPANY" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
COMPANY_NAME_UPPER=$(echo "$COMPANY" | sed 's/.*/\u&/')
OUTPUT_DIR="${COMPANY_SLUG}-systems"

# Validate prerequisites
if [ ! -f "$ROOT_DIR/companies/$COMPANY/COMPANY.md" ]; then
    echo "Error: companies/$COMPANY/COMPANY.md not found."
    echo ""
    echo "Create the company profile first:"
    echo "  cp -r companies/_template companies/$COMPANY"
    echo "  # Then fill in companies/$COMPANY/COMPANY.md"
    exit 1
fi

echo "Generating ${OUTPUT_DIR}/ for ${COMPANY}..."

# Create output directory structure
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/skills"
mkdir -p "$OUTPUT_DIR/workflows"
mkdir -p "$OUTPUT_DIR/prds"
mkdir -p "$OUTPUT_DIR/.claude"
mkdir -p "$OUTPUT_DIR/outputs"

# 1. Copy COMPANY.md from company profile to root
cp "$ROOT_DIR/companies/$COMPANY/COMPANY.md" "$OUTPUT_DIR/COMPANY.md"
echo "  Copied COMPANY.md"

# 2. Copy PRD system definition
mkdir -p "$OUTPUT_DIR/systems/prd"
cp "$ROOT_DIR/systems/prd/SYSTEM.md" "$OUTPUT_DIR/systems/prd/SYSTEM.md"
cp "$ROOT_DIR/systems/prd/README.md" "$OUTPUT_DIR/systems/prd/README.md"
echo "  Copied PRD system"

# 3. Copy PRD skills
PRD_SKILLS=(prd-author prd-taskmaster prd-validator prd-learner)
for skill in "${PRD_SKILLS[@]}"; do
    if [ -d "$ROOT_DIR/skills/$skill" ]; then
        mkdir -p "$OUTPUT_DIR/skills/$skill"
        cp "$ROOT_DIR/skills/$skill/SKILL.md" "$OUTPUT_DIR/skills/$skill/SKILL.md"
    fi
done
echo "  Copied ${#PRD_SKILLS[@]} skills"

# 4. Generate CLAUDE.md from template
CLAUDE_TEMPLATE="$ROOT_DIR/deploy/templates/company-CLAUDE.md"
if [ -f "$CLAUDE_TEMPLATE" ]; then
    sed "s/{{COMPANY_NAME}}/$COMPANY_NAME_UPPER/g" "$CLAUDE_TEMPLATE" > "$OUTPUT_DIR/CLAUDE.md"
    echo "  Generated CLAUDE.md"
fi

# 5. Generate README.md from template
README_TEMPLATE="$ROOT_DIR/deploy/templates/company-README.md"
if [ -f "$README_TEMPLATE" ]; then
    sed -e "s/{{COMPANY_NAME}}/$COMPANY_NAME_UPPER/g" \
        -e "s/{{COMPANY_SLUG}}/$COMPANY_SLUG/g" \
        "$README_TEMPLATE" > "$OUTPUT_DIR/README.md"
    echo "  Generated README.md"
fi

# 6. Generate SETUP.md from template
SETUP_TEMPLATE="$ROOT_DIR/deploy/templates/company-SETUP.md"
if [ -f "$SETUP_TEMPLATE" ]; then
    sed -e "s/{{COMPANY_NAME}}/$COMPANY_NAME_UPPER/g" \
        -e "s/{{COMPANY_SLUG}}/$COMPANY_SLUG/g" \
        "$SETUP_TEMPLATE" > "$OUTPUT_DIR/SETUP.md"
    echo "  Generated SETUP.md"
fi

# 7. Copy workflow templates
for wf in product/prd-new-engagement.yaml product/prd-post-build.yaml; do
    if [ -f "$ROOT_DIR/workflows/$wf" ]; then
        mkdir -p "$OUTPUT_DIR/workflows/$(dirname $wf)"
        sed "s/company: active/company: $COMPANY_SLUG/g" "$ROOT_DIR/workflows/$wf" > "$OUTPUT_DIR/workflows/$wf"
    fi
done
if [ -f "$ROOT_DIR/workflows/_template.yaml" ]; then
    cp "$ROOT_DIR/workflows/_template.yaml" "$OUTPUT_DIR/workflows/_template.yaml"
fi
echo "  Copied workflow templates"

# 8. Copy PRDs if they exist
if [ -d "$ROOT_DIR/companies/$COMPANY/prds" ]; then
    cp -r "$ROOT_DIR/companies/$COMPANY/prds/"* "$OUTPUT_DIR/prds/" 2>/dev/null || true
    echo "  Copied existing PRDs"
fi

# 9. Create .claude/settings.json
if [ -f "$ROOT_DIR/deploy/templates/claude-settings.json" ]; then
    cp "$ROOT_DIR/deploy/templates/claude-settings.json" "$OUTPUT_DIR/.claude/settings.json"
fi
echo "  Created .claude/settings.json"

# 10. Create .gitignore
cat > "$OUTPUT_DIR/.gitignore" << 'EOF'
outputs/
.DS_Store
.mcp.json
.claude/settings.local.json
EOF
echo "  Created .gitignore"

# 11. Init git repo
cd "$OUTPUT_DIR"
git init -q
git add -A
git commit -q -m "Initialize ${COMPANY_NAME_UPPER} standalone deployment

Generated from Systems Please."
cd ..

echo ""
echo "Done! ${OUTPUT_DIR}/ is ready."
echo ""
echo "Next steps:"
echo "  1. cd ${OUTPUT_DIR}"
echo "  2. Review COMPANY.md and update any placeholders"
echo "  3. Run 'claude' to start using the system"
echo "  4. Create a GitHub repo and push: git remote add origin <url> && git push -u origin main"
