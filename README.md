# Oui!

> Multi-platform UI library for Flutter.

```
1. The first letter of OneZero is O.
2. Zero is also known as O.
When you add ui to the end of O, you get oui.
```

Used in most of the apps produced by OneZero.

## Structure of `oui`

```mermaid
graph TD
  Routing[External Routing]@{ shape: text } ---->|Provides URL| Router
  Screens -->|tell router to add or remove a screen| Router
  App[App Instance] --> Router
  App --> Theme
  App --> Scaffold
  Router <-->|Communicate to decide which screens to show in which order| Scaffold
  Scaffold ---> Output[What the user sees]@{ shape: text }
  Screens --> Scaffold
  Theme -->|provide typography, colors and various settings| Screens
  Components[Component Library] -->|buttons, text, inputs| Screens
```

## CI Build Status

![CI](https://github.com/onezerocompany/oui/actions/workflows/ci.yml/badge.svg)

#### Code Coverage on the `main` branch

![Coverage](https://codecov.io/gh/onezerocompany/oui/graphs/sunburst.svg?token=AFSGsPs8ch)

## Running Tests Locally

To run tests locally, use the following command:

```sh
flutter test
```
