---
status: proposed
date: 2024-10-13
decision-makers:
consulted:
informed:
---

# Use Architectural Design Records

## Context and Problem Statement

We want to document architectural decisions governing scaf explicitly,
with open communication and open decision-making around these
decisions.

## Decision Drivers

* Decisions made around scaf's design and architecture have not always
  been made openly and with stakeholder input.
* When decisions are made, they are often not thought through.
  Implications that might affect some of the details do not get
  adequately considered.
* Decisions are not always communicated to everyone affected by those
  decisions.

## Considered Options

* Internal: document architectural decisions somewhere else, possibly
  with an internal tool used by Six Feet Up.
* MADR: the [Markdown Architectural Decision Record
  convention](https://github.com/adr/madr/), with files managed and
  committed to the scaf repository.
* Nygard: [the original template created by Michael
  Nygard](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions),
  with files managed and committed to the scaf repository.
* None: do not make explicit architectural decisions; let the
  architecture reflect whatever ideas people come up with to solve
  problems.

## Decision Outcome

Chosen option: "MADR", because:

* Documenting architectural decisions has broad appeal among our
  developers.
* MADR seems to be a popular set of conventions in the community; for
  example, the upstream repository has over 1000 stars, and it is
  linked as an authority on the subject by
  [Amazon](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/adr-process.html)
  and
  [Microsoft](https://learn.microsoft.com/en-us/azure/well-architected/architect-role/architecture-decision-record).
* Maintaining documentation files in the git repository and viewable
  in public on GitHub ensures that the current list of decisions is
  open to everyone relying on the project, and it allows others to
  comment on those documents as they make their way through review
  (for example, by putting comments and reviews on pull requests
  containing a MADR file).

### Consequences

* Good, because architectural decisions will be documented.
* Good, because architectural decisions are public and available as
  project documentation.
* Good, because changes or new proposals are kept with the project,
  and contradictions between decision and implementation can be more
  easily pointed out.
* Good, because decisions can be discussed before they are decided.
* Good, because the history of decisions is preserved in version
  control.
* Good, because Markdown is a relatively simple format to write in,
  and it is well-supported within the industry.
* Good, because this specific format has been revised to reflect
  experience using the format.
* Bad, because publicity may mean important details of decisions
  cannot be documented.

### Confirmation

Switching the status in the metadata at the top of this document and
merging it into the main branch will confirm the primary decision.

Note that merging this document by itself does NOT constitute
confirmation without an explicit step to change the status.  It is
expected that decisions will be accepted as documents even if they are
rejected or superseded; documentation of non-decisions or rejections
can be even more valuable at times, and revisiting decisions in new
ADRs should be encouraged.

## Pros and Cons of the Options

### Internal

Note that this option has us documenting decisions, but not in a
transparent or open way.

* Good, because architectural decisions will be documented.
* Good, because potentially sensitive portions of decisions can be
  documented if the decisions are not documented in public.
* Bad, because stakeholders outside Six Feet Up will not have insight
  into the decisions being made.
* Bad, because stakeholders outside Six Feet Up will not have the
  ability to comment or provide feedback on decisions, which may be
  valuable or describe a concern that may not apply to us, but still
  might be good to consider.
* Bad, because decisions are not kept with the project itself, and can
  thus get out of sync easily, with the delta not being as easily
  seen.

### MADR

* Good, because architectural decisions will be documented.
* Good, because architectural decisions are public and available as
  project documentation.
* Good, because changes or new proposals are kept with the project,
  and contradictions between decision and implementation can be more
  easily pointed out.
* Good, because decisions can be discussed before they are decided.
* Good, because the history of decisions is preserved in version
  control.
* Good, because Markdown is a relatively simple format to write in,
  and it is well-supported within the industry.
* Good, because this specific format has been revised to reflect
  experience using the format.
* Bad, because publicity may mean important details of decisions
  cannot be documented.

### Nygard

* Good, because architectural decisions will be documented.
* Good, because architectural decisions are public and available as
  project documentation.
* Good, because changes or new proposals are kept with the project,
  and contradictions between decision and implementation can be more
  easily pointed out.
* Good, because decisions can be discussed before they are decided.
* Good, because the history of decisions is preserved in version
  control.
* Bad, because publicity may mean important details of decisions
  cannot be documented.
* Bad, because the Nygard template is not specific; it represents more
  of a guideline than a template.
* Bad, because the Nygard template has not been updated since its
  proposal in 2011.

### None

* Bad, because we will not have a formal way to make decisions.
* Bad, because we will not have a formal way to record decisions.
* Bad, because we will not have a formal way to discover previous
  decisions.

## More Information

This proposal assumes the conclusion being proposed, and is a bit
unusual in this way.  If a different decision is made, this document
should be changed in whatever ways make sense to implement the
different decision.

No assumptions are made here outside the stated goal.  Process,
tooling, and other details should be considered in separate ADRs
unless those decisions materially impact the decision to use MADR at
all.  It is expected that conventions around the shared template will
develop organically.

This particular ADR fills out as much of the template as possible on
purpose, to act as an example as well as a decision.  Nothing about
this document's verbosity should be seen as a commentary about how
optional the optional fields in the template may or may not be, nor
should it be considered the final answer on how to fill out a MADR.

The template, as included, should also be reviewed when reviewing this
proposal.
