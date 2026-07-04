---
name: a11y-conventions
description: Apply baseline web accessibility practices when creating or editing UI - components, forms, or pages. Use whenever writing or modifying anything that renders to a browser.
---

# Accessibility conventions

Apply these whenever you write or edit UI, regardless of framework.

## Semantic HTML first

Use the tag that means what you mean: `<button>` for actions, `<a>` for
navigation, `<nav>` / `<main>` / `<header>` / `<footer>` for layout regions.
Don't reach for a clickable `<div>` when a native element gives you keyboard
support and screen-reader semantics for free.

## Forms

- Every input needs a linked `<label>` (via `for`/`id`, or by wrapping it) -
  a placeholder is not a label.
- Group related fields with `<fieldset>` and `<legend>` where it makes sense
  (radio groups, for example).
- Show validation errors as text tied to the field (`aria-describedby`), not
  color alone.

## Images and icons

- Every meaningful `<img>` needs real `alt` text describing its content or
  purpose. Purely decorative images get `alt=""`, not a missing attribute.
- Icon-only buttons need an accessible name (`aria-label`, or visually-hidden
  text) - an icon alone isn't announced by a screen reader.

## Keyboard and focus

- Anything interactive must be reachable and operable by keyboard (Tab,
  Enter/Space). Mentally test this for anything you build with a click handler.
- Don't remove focus outlines without providing a visible replacement style.
- Modals and dialogs should trap focus while open and return it to the
  triggering element on close.

## Color and contrast

- Don't rely on color alone to convey meaning (status, errors) - pair it with
  text or an icon.
- Body text should meet roughly 4.5:1 contrast against its background; large
  text can go a bit lower.

## When you're not sure

Flag the uncertainty instead of guessing silently. A one-line note like "this
modal should trap focus - confirming the library handles that" is enough.
