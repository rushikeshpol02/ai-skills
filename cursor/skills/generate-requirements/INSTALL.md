# Installing the generate-requirements Skill

## File Structure

```
generate-requirements/
├── SKILL.md                     ← Entry point (skill description + intake)
├── workflows/
│   ├── 01-synthesize.md         ← Workflow 1: Context synthesis
│   ├── 02-generate.md           ← Workflow 2: Document generation
│   └── 03-validate.md           ← Workflow 3: Validation
└── templates/
    ├── context-summary.md        ← Internal artifact template
    ├── feature-requirements.md   ← Feature Requirements output template
    ├── api-contract.md           ← API Contract output template
    └── system-flow.md            ← System Flow output template
```

---

## How to Install

Copy the `generate-requirements/` folder (excluding this INSTALL.md) to your Cowork skills directory:

```bash
cp -r _skills/generate-requirements ~/.skills/skills/
```

Or in the Cowork app: use the **Plugin/Skill Manager** to install from a folder.

Once installed, the skill appears as `generate-requirements` in your skill list.

---

## How to Use

In any Cowork session, say:

```
/generate-requirements
```

Or:

```
Generate requirements for [feature name]
```

The skill will:
1. Scan your workspace for PRDs, Swagger files, designs
2. Ask a few intake questions (feature name, mode, inputs)
3. Run Workflow 1 → 2 → 3 automatically, waiting for your approval at each step
4. Save all outputs to `requirements/[feature-name]/`

---

## What Gets Saved

After running, your workspace will contain:

```
requirements/
└── [feature-name]/
    ├── Context-Summary-[Feature].md        ← Internal analysis (not for sharing)
    ├── Feature-Requirements-[Feature].md   ← Always generated
    ├── API-Contract-[Feature].md           ← If APIs in scope (Comprehensive)
    ├── System-Flow-[Feature].md            ← If integrations in scope (Comprehensive)
    └── Validation-Report-[Feature].md      ← Quality gate report
```

---

## Tips

- **Quick Mode:** For MVPs and small features. Generates Feature Requirements only.
- **Comprehensive Mode:** For production features with APIs or integrations. Generates up to 3 docs.
- **Resume:** If you have an existing Context Summary, you can start from Workflow 2 directly.
- **Design files:** Provide Figma URLs or upload images — analyzed automatically in Workflow 1.
- **Swagger:** Upload your existing OpenAPI spec — patterns extracted and applied to API Contract.
