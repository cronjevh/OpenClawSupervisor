# Initiative PR Workflow

This folder is intended to support substantial work using external subscription-based coding agents rather than per-token interactive execution inside supervisor.

## Goal

Provide a repeatable way to take an initiative from a markdown stub to a tracked implementation branch and pull request.

## Working Model

1. Use `initiatives/README.md` as the top-level directory.
2. Use each initiative stub as the durable problem statement.
3. When a piece of work becomes concrete, create a bounded implementation request.
4. Run that request through an external subscription-based agent flow.
5. Land the result on a branch with a reviewable PR.
6. Link the resulting issue/branch/PR back into the initiative page.

## Preferred Artifacts

For each meaningful work package, aim to create:
- a short implementation brief
- a GitHub issue if the work needs durable queueing
- a branch name tied to the initiative and work package
- a pull request with clear verification notes

## Suggested Branch Naming

Use names that are easy to associate back to the initiative, for example:
- `initiative/whatsapp-triage-discovery`
- `initiative/monica-engagement-research`
- `initiative/ha-maintenance-nightly-healthcheck`
- `initiative/home-maintenance-register-v1`

## Suggested Pull Request Structure

PR title pattern:
- `initiative: <initiative short name> - <work package>`

PR body should include:
- objective
- why now
- scope of this PR
- out of scope
- verification performed
- next follow-up work package

## External Agent Handoff Template

Use this as a seed when handing work to an external subscription-based agent:

### Context
- Initiative: <name>
- Source stub: `initiatives/<file>.md`
- Objective: <bounded objective>
- Constraints: keep changes reviewable, safe, and reversible

### Deliverable
- Implement the smallest useful step toward the initiative
- Update the initiative stub with progress notes
- Create or update any supporting docs/scripts needed
- Commit changes cleanly on a dedicated branch
- Open a PR with verification notes

### Safety Rules
- Do not make destructive production changes without explicit approval
- Prefer scaffolding, docs, and safe automation primitives first
- Keep commits logically grouped

## Link-Back Discipline

When issue/branch/PR artifacts are created, add a short section to the initiative page:
- issue link
- branch name
- PR link
- date opened
- current status

## Supervisor Role

Supervisor should stay the field medic and control point:
- shape the work
- create the bounded handoff
- review outputs
- track links and status
- avoid doing large expensive implementation work inline when a subscription flow is better suited
