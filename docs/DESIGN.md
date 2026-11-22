# The Leak — Design System, v2 "Tabloid"

The app looks like a Mumbai evening newspaper. Most screens are the **quiet** version: newsprint background, one big headline, thin rules, square black buttons. Only **Reveal** and **Trip Wrapped** use the **loud** front-page treatment.

Live canvas: https://claude.ai/artifact/RPStrqtZEEKk91BFtcdxRH (page "v2 — Tabloid").
Static copies: `design/screens/*.html` (open in a browser; needs internet for Google Fonts in the browser preview only).

## 1. Principles
1. **One headline per screen.** A single Anton heading says what the screen is for.
2. **One main action**, a full-width black button at the bottom. Red only for the moment that matters (Word guessed, your vote pick, the Insider, Share).
3. **Rules, not cards.** Group content with horizontal rules (3 px heavy above a section, 1 px light between rows). No rounded cards, no shadows on quiet screens.
4. **Square corners everywhere.** Radius 0 on buttons, inputs, toggles, rows.
5. **Big touch targets.** Minimum 44 px; main buttons 56 px; the +1 button 168 px tall.
6. **Secrets are hidden by default.** Roles and the word appear only while held, or on Reveal.

## 2. Colour tokens
| Token | Hex | Use |
|---|---|---|
| `paper` | `#F1ECDF` | Background of all quiet screens |
| `paperRaised` | `#FBF8F0` | Inputs, role card body |
| `paperLoud` | `#EDE7D7` | Reveal background (with halftone dots) |
| `ink` | `#141210` | Text, primary buttons, heavy rules, selected rows |
| `inkMuted` | `#4F493E` | Secondary text |
| `inkFaint` | `#8A8270` | Row numbers, dotted rules, dashed input borders |
| `ruleLight` | `#C9C0AC` | 1 px row dividers, empty progress segments |
| `counterSuffix` | `#A39A86` | "/ 20" next to the counter |
| `red` | `#C8201A` | Masthead, accent labels, Word guessed, vote pick, Insider role, Share |
| `onInk` | `#FFFFFF` | Text on ink or red |
| `desk` | `#2A2722` | Background behind the Trip Wrapped card |

## 3. Typography (bundle all fonts as assets)
| Style | Font | Size / weight | Tracking | Use |
|---|---|---|---|---|
| `displayHuge` | Anton | 104–190 | 0 | Counter number, Reveal headline, names on pass screen (112) |
| `displayLarge` | Anton | 48–68 | 0 | Screen titles ("ROUND 13", "STANDINGS"), Home masthead (68) |
| `displayMedium` | Anton | 28–36 | 0 | Trip names, champion name |
| `button` | Anton | 19–22 | 0.08em | All primary and outline buttons, uppercase |
| `label` | Libre Franklin | 11 / 800 | 0.16em | Section labels, headers, tags, uppercase |
| `body` | Libre Franklin | 15–18 / 500–700 | 0 | Names in lists, body text |
| `voice` | Libre Caslon Text Italic | 15–20 / 400 | 0 | Subtitles ("Priya is the Master this round"), prompts, captions |

Headlines and buttons are always uppercase. Body and voice text are sentence case.

## 4. Spacing and layout
- Screen padding: 20 px left/right, 44 px top (below the status bar), 24 px bottom.
- Vertical rhythm: 14–18 px between blocks.
- The main action sits at the bottom (push with a flexible spacer).
- Phone frame reference: 390 × 844.

## 5. Components
| Component | Spec |
|---|---|
| **Section header row** | Label style on the left (and optional label on the right), 8 px padding below, 1 px `ink` bottom rule |
| **Heavy section rule** | 3 px `ink` top border above a list or block |
| **Primary button** | 56 px, full width, `ink` fill, `onInk` Anton 21 uppercase, 0.08em tracking |
| **Highlight button** | Same as primary with `red` fill (Word guessed, Share image) |
| **Outline button** | 46–56 px, 2 px `ink` border, transparent, Franklin 13–14/800 uppercase 0.12–0.14em, or Anton 19–21 for big ones |
| **Text button** | Franklin 13/800 uppercase, underline offset 4 px (Undo) |
| **Icon button** | 44 × 44, 2 px `ink` border, square, 20 px stroke icon |
| **List row** | 50–64 px, 1 px `ruleLight` bottom border, name in body 17–20 |
| **Selected row** | `ink` fill with white text and a check; vote pick uses `red` fill with a "VOTED OUT" label |
| **Text input** | 50 px, 2 px `ink` border, `paperRaised` fill; "add" input uses 2 px dashed `inkFaint` |
| **Segmented control** | 2 px `ink` outer border, 2 px dividers, selected segment `ink` fill white text |
| **Toggle** | 60 × 32 square, 2 px `ink` border; on = `ink` fill with a `paper` knob on the right |
| **Progress segments** | 5 px tall bars with 4 px gaps; done = `ink`, pending = `ruleLight` |
| **Progress bar** | 12 px tall, 2 px `ink` border, `ink` fill |
| **Note line** | Red label ("NOTE", "DRIVER", "CAR MODE") inline before muted body text, with 1 px rules above |
| **Role card** | 3 px `ink` border, `paperRaised` body, red strip "TOP SECRET · FOR YOUR EYES ONLY", role name Anton 62 (Insider in `red`), job in voice style, word under a 1 px rule |

## 6. The secret word in the real app
Mockups show a black redaction bar wherever the word appears. In the app:
- **Role card** (Master and Insider only): the word in Anton 44 `ink` under the "SECRET WORD" label.
- **Master peek:** the same, shown only while the eye icon is held.
- **Reveal:** "THE WORD" label, then the word in Anton 28 `ink`.

## 7. Per-screen notes
| Screen | File | Notes |
|---|---|---|
| Home | `01_home.html` | Masthead "THE LEAK" Anton 68 with an 8 px red rule; Continue block; two outline buttons; Car mode note at the bottom |
| Trip setup | `02_trip_setup.html` | Numbered seat-order rows with a "Drives" checkbox column |
| Round setup | `03_round_setup.html` | Car mode toggle row; driver picker as two big square buttons; difficulty segmented control |
| Pass the phone | `04a_handout_pass.html` | Name at Anton 112 with a short red rule; 180 px black hold button |
| Role revealed | `04b_handout_role.html` | Role card; "+3" scoring line; "The card closes by itself" with a 12 px countdown bar (4 s) in place of the Done button; Done appears on the pass screen after the card closes |
| Round (Master) | `05_round_master.html` | Counter Anton 190; 168 px +1 button; Word guessed red, Not guessed outline |
| Who guessed | `06_who_guessed.html` | Rule-separated list; selected row in ink |
| Discussion | `07_discussion.html` | Timer Anton 132 with "OF 2:00"; numbered prompts in voice style |
| Vote | `08_vote.html` | One group vote: header "ROUND 13 · GROUP VOTE"; "Agree on one name. Who is the" (voice) + "LEAK?" (Anton 56); red selected row tagged "VOTED OUT"; button "VOTE OUT <NAME>". No pass gates or step segments |
| Reveal (loud) | `09_reveal.html` | Red masthead, dateline, "EXCLUSIVE" tag, Anton 104 headline, voice deck, halftone photo box with caption, "The car voted out" name (red when it was the Leak) and a points column, black primary "CONTINUED IN ROUND 14 ▸" |
| Standings | `10_standings.html` | Underlined text tabs (active = 4 px red underline); sports-table layout; leader row in ink |
| Trip Wrapped (loud) | `11_trip_wrapped.html` | Front-page card 342 × 608 on `desk`; "CASE CLOSED" Anton 62; champion block in ink; awards with dotted leaders; red Share image |

## 8. Flutter guidance
- Build a `ThemeData` with `scaffoldBackgroundColor: paper`, every shape `RoundedRectangleBorder(borderRadius: BorderRadius.zero)` or `BeveledRectangleBorder` with zero radius, no elevation, and a `TextTheme` mapped from section 3.
- Put reusable pieces in `presentation/widgets/` (`SectionHeader`, `InkButton`, `OutlineInkButton`, `RuleListRow`, `SquareToggle`, `SegmentedSquare`, `ProgressSegments`, `HoldToReveal`).
- Halftone texture on Reveal: a small repeating dot `CustomPainter` (1 px dots on a 5 px grid at 6% ink).
- Trip Wrapped image: render the card widget inside a `RepaintBoundary` at 3× pixel ratio.
- Respect system text scaling up to 1.3×; large Anton headings may use `FittedBox` to stay on one line.
