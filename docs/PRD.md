# The Leak — Product Requirements, v1

**Owner:** Pranit · **Date:** 20 Nov 2026 · **Status:** Ready to build

## 1. Summary
The Leak is a single-phone, offline social deduction party game for 4 to 8 friends. Each round the group has 20 yes/no questions to find a secret word, then votes to catch the leak: the Insider who secretly knew it all along. **Car mode** lets the driver play every round without touching or looking at the screen, which is the selling point for road trips.

- **Positioning:** a party game for friends you can play anywhere; Car mode is the hook in the store listing and screenshots.
- **Platform:** Flutter, Android first; iOS later from the same code.
- **Network:** none. Everything works offline.
- **v1 goal:** playable build by 23 Dec 2026, on the Play internal testing track by 28 Dec 2026.
- **Name:** The Leak (see 1.1).

### 1.1 Name and identity
| Item | Value |
|---|---|
| App name | **The Leak** |
| Play Store title | The Leak: Find the Insider |
| In-app masthead | THE LEAK |
| Package name | `com.bytecode.theleak` |
| Role name in UI copy | The hidden role is shown to players as **"The Leak"** (role card "THE LEAK", "Find the leak", "who is the LEAK?", "The leak was Amit"). These docs and the code call the same role **Insider** (`insiderId`, "Insider survival rate"). |

## 2. Game rules

### 2.1 Roles
| Role | Count | Known to all? | Knows the word? | Job |
|---|---|---|---|---|
| Master | 1 | Yes | Yes | Answers questions aloud (yes / no / doesn't matter), holds the phone, taps the counter |
| Insider | 1 | No | Yes | Asks questions like everyone else and quietly steers the group to the word |
| Common | Everyone else | Yes, as a group | No | Asks questions, cracks the word, finds the Insider |

Role rules:
- **Car mode on:** the current driver is always a Common. He can never be Master or Insider and is not a vote candidate.
- **Car mode off:** every player is eligible for every role.
- The Master rotates through eligible players in seat order (skipping the current driver in Car mode).
- The Insider is picked at random from eligible players other than the Master, and never the same person two rounds running.

### 2.2 Round flow
1. **Setup:** turn Car mode on or off (when on, pick who is driving now) and choose difficulty.
2. **Role handout:** the phone goes to each eligible player in seat order. Each holds to see their role (and the word, if Master or Insider) and lifts their finger to hide it. In Car mode the driver is skipped. The Master goes last, so the phone ends with the Master.
3. **Round starts:** the app announces it aloud.
4. **Questions:** players ask yes/no questions in any order. The Master answers aloud and taps **+1** for every question. A guess ("Is it a ___?") counts as a question. Undo is available.
5. **Round ends:** the Master taps **Word guessed** (then picks who said it) or **Not guessed** (20 used up, or the group gives up).
6. **Discussion:** 2 minutes to argue about who the Insider is. Skippable.
7. **Vote:** each passenger votes privately on the phone. In Car mode the driver says his vote aloud and the Master enters it. Nobody can vote for themselves; the Master (and, in Car mode, the driver) are not candidates.
8. **Reveal:** the app announces whether the Insider was caught, shows the word and adds points.

If the word is not guessed, steps 6 and 7 are skipped and the app goes straight to the reveal.

### 2.3 Scoring
| Outcome | Commons | Insider | Master |
|---|---|---|---|
| Word found, Insider caught | +2 each | 0 | +1 |
| Word found, Insider not caught | 0 | +3 | 0 |
| Word not found | 0 | 0 | 0 |

- **Caught** means the Insider got strictly the most votes. A tie counts as not caught.
- In Car mode the driver scores as a Common like anyone else.

### 2.4 Settings (defaults)
- Question limit: 20 (range 10–30)
- Discussion timer: 2 minutes (off, or 1–5 minutes)
- Spoken milestone alerts: on

## 3. Screens
Visual reference for every screen: `design/screens/`. Design rules: `docs/DESIGN.md`.

**Navigation:** Home → Trip setup → Round setup → Role handout → Round → either (Word guessed → Who guessed → Discussion → Vote) or (Not guessed) → Reveal → Round setup for the next round, or Standings / Trip Wrapped.

| # | Screen | Mockup file | Holds the phone |
|---|---|---|---|
| 1 | Home | `01_home.html` | Anyone |
| 2 | Trip setup | `02_trip_setup.html` | Anyone |
| 3 | Round setup | `03_round_setup.html` | Anyone |
| 4a | Role handout — pass the phone | `04a_handout_pass.html` | Each player in turn |
| 4b | Role handout — role revealed | `04b_handout_role.html` | Each player in turn |
| 5 | Round (Master) | `05_round_master.html` | Master |
| 6 | Who guessed | `06_who_guessed.html` | Master |
| 7 | Discussion | `07_discussion.html` | Master |
| 8 | Vote | `08_vote.html` | Each passenger in turn |
| 9 | Reveal | `09_reveal.html` | Master |
| 10 | Standings | `10_standings.html` | Anyone |
| 11 | Trip Wrapped | `11_trip_wrapped.html` | Anyone |

### Screen details
1. **Home**
   - Continue block (trip name, rounds played, current leader) when an unfinished trip exists, with **Resume trip**.
   - New trip; Standings; Settings (question limit, discussion timer, spoken alerts, test voice).
   - Empty state: masthead plus a single **Start your first trip** button.
2. **Trip setup**
   - Trip name (default: "Trip – <today's date>").
   - Add player field + Add; long-press and drag to set seat order; swipe to delete; "Drives" checkbox per player.
   - Validation: 4 to 8 players, unique names. With no drivers marked, Car mode is disabled.
   - Players can be added or removed between rounds; a removed player keeps past stats.
3. **Round setup**
   - Round number and "<name> is the Master this round".
   - Car mode switch (remembers the last setting); when on, a "Who's driving now?" picker from players marked as drivers.
   - Difficulty: Easy / Medium / Hard / Mixed. **Start round**.
   - Validation: Car mode needs at least 3 non-driving players.
4. **Role handout**
   - Pass screen: "Pass the phone to <NAME>", progress segments, big **Hold to see** button.
   - While held: role card ("TOP SECRET" notice) with role name, one-line job, and the word for Master or Insider. Lifting the finger hides it instantly.
   - **Done · pass to <next>** moves on. Back gesture disabled.
5. **Round (Master)**
   - Header: round number, "Master: <name>", hold-to-peek-word icon, mute icon.
   - Huge counter "7 / 20", progress bar, "13 questions left".
   - Big **+1** button (bottom half, one-thumb reach), **Undo** text button.
   - **Word guessed** (red) and **Not guessed** (outline).
   - At the limit: +1 disabled and a prompt "Out of questions?" leading to Not guessed.
   - Screen kept awake; haptic tick on +1.
6. **Who guessed:** player list without the Master (driver included, tagged DRIVER); pick one, confirm.
7. **Discussion:** big countdown with progress bar, two discussion prompts, **Skip to the vote**. Auto-advances at zero. Skipped if the timer is off.
8. **Vote**
   - Per passenger in seat order: pass gate, then the candidate list (everyone except themselves, the Master and the Car mode driver), **Lock vote**.
   - The Master votes in their own turn. Car mode: last step "Driver, say your vote", the Master taps the name.
   - A locked vote cannot be changed.
9. **Reveal** (the one "loud" screen — tabloid front page)
   - Masthead, dateline (trip, round, date), huge **CAUGHT!** or **ESCAPED!** or **NOT FOUND** headline.
   - One-sentence story deck, e.g. "<Insider> exposed as the leak in a 4–2 vote after the car cracked the word in just seven questions."
   - Halftone "photo" placeholder with a caption from a bundled pool of fun captions (see 3.1).
   - "How the car voted" list with points per player; "The word" with the actual word.
   - **Continued in round <n+1>**, Standings, End trip.
10. **Standings:** tabs Points / Stats / History. Points = newspaper-style table (POS, PLAYER, RND, PTS). Stats = every stat in section 5. History = one row per round (round, Insider, result).
11. **Trip Wrapped:** a shareable "CASE CLOSED" special-edition front page: trip name and dates, rounds, champion, all awards. **Share image** and **Save**.

### 3.1 Reveal headlines and captions
- Headline by outcome: caught → "CAUGHT!", not caught → "ESCAPED!", not found → "NOT FOUND".
- The deck sentence is templated from round data (names, vote split, questions used). Write numbers under ten as words.
- Caption pool: about 30 short, light-hearted captions per outcome in `assets/copy/captions_v1.json`, picked at random without repeating within a trip. Captions must never mention or hint at the word.

## 4. Spoken announcements
Spoken through the phone's audio, which plays through the car speakers on Bluetooth. Indian English voice (`en-IN`).

| Trigger | Line (example) |
|---|---|
| Round starts | "Round 4. Priya is the Master. Start asking." |
| 10 / 5 / 1 questions left | "Ten questions left." / "Five questions left." / "Last question." |
| Word guessed | "Word guessed by Rohan! Two minutes to find the leak." |
| Discussion, 30 s left | "Thirty seconds." |
| Vote starts | "Time to vote." In Car mode: "Time to vote. Driver, say your vote out loud." |
| Reveal, caught | "The leak was Amit. Caught! The word was [word]." |
| Reveal, not caught | "The leak was Amit, and nobody caught him. The word was [word]." |
| Reveal, word not found | "Out of questions. The word was [word], and the leak was Amit." |
| First round of a new day | "Day 4. Rohan leads with 18 points, Priya is second with 15." |

- Milestone alerts follow the question limit and can be turned off.
- Never speak a role or the word before the reveal.
- Mute toggle on the Round screen.

## 5. Trip stats
All stats are computed from saved rounds of the current trip.

| Stat | Calculation | Award title | Minimum to qualify |
|---|---|---|---|
| Points | Sum of round points | Champion / MVP | none |
| Insider survival rate | Rounds as Insider where the word was found and not caught ÷ rounds as Insider | The Snake | 2 rounds as Insider |
| Detective accuracy | Votes for the actual Insider ÷ votes cast (rounds where you were not the Insider) | Sherlock | 3 votes |
| Word cracker | Rounds where you said the word | Word Cracker | 1 |
| Fastest crack | Fewest questions used in a round you cracked | Speed Demon | 1 crack |
| Master success rate | Rounds as Master where the word was found ÷ rounds as Master | Best Host | 2 rounds as Master |
| Most falsely accused | Votes received in rounds where you were not the Insider | Always Suspected | 1 vote |

- Rates show as a percentage with the count, e.g. "67% (2 of 3)".
- Ties for an award: higher points wins; still tied, both get it.
- Trip Wrapped is available after 10 rounds or when the user taps End trip.

## 6. Word decks (sealed)
- About 300 words in `assets/decks/words_v1.json`, at least 100 per difficulty, no repeats within a trip.
- **No actual words appear in these docs.** The deck is generated by the build agent from the rules below without anyone on the team reading it (see `CLAUDE.md`).

| Category | What goes in it |
|---|---|
| Food | Dishes, snacks, drinks and ingredients known across India |
| Bollywood and OTT | Films, shows, famous scenes and film-world terms |
| Cricket and sports | Shots, formats, rules, famous moments |
| Places | Landmarks, cities, regions, everyday places |
| Daily life in India | Vehicles, documents, events, household things |
| Brands | Well-known Indian and global brands and mascots |
| Tech and internet | Apps, payment systems, everyday tech terms |
| Professions | Jobs and roles everyone recognises |

| Difficulty | Meaning |
|---|---|
| Easy | Everyone knows it; reachable in under 10 questions |
| Medium | Well known; takes 10–15 good questions |
| Hard | Well known but needs clever questions; often cracked near 20 |

Word rules: concrete nouns, well-known names and everyday things that can be cracked with yes/no questions. No verbs, abstract ideas or obscure trivia. No politics, religion-based words, or anything embarrassing in front of family.

Format:
```json
[
  { "id": "food_001", "word": "<word>", "category": "food", "difficulty": "easy" }
]
```

## 7. Scope
**Not in v1:** ads or in-app purchases; accounts, cloud sync or multiple phones; AI Master mode; regional-language decks; iOS release.

## 8. Build order
1. **20–26 Nov:** Flutter project, theme from `docs/DESIGN.md`, Trip setup, players and seat order, game engine (`assignRoles`, `pickWord`) with unit tests, Role handout screens.
2. **27 Nov–3 Dec:** Round screen with counter, Who guessed, Discussion, Vote, Reveal, scoring.
3. **4–10 Dec:** Spoken announcements, Standings, all trip stats, resume after app kill.
4. **11–17 Dec:** 300-word sealed deck, caption pool, Trip Wrapped card and sharing, polish.
5. **18–23 Dec:** playtest with friends; fix issues. **Playable build by 23 Dec.**
6. **28 Dec:** Play internal testing track.

## 9. Acceptance criteria
- [ ] 6 players finish 10 rounds in a row with no crash or stuck screen.
- [ ] In Car mode the driver never needs to look at the phone for a whole round.
- [ ] Roles and the word are never on screen unless a player is holding to reveal (or on the Reveal screen).
- [ ] Counter, +1, Undo and the question-limit stop behave as specified.
- [ ] Points and every stat match a hand count of the same rounds.
- [ ] Killing the app mid-round and reopening resumes the round on the right screen and player.
- [ ] Announcements play through car Bluetooth audio.
- [ ] Works fully in airplane mode.
- [ ] Trip Wrapped shares to WhatsApp as an image.
- [ ] Screens match `design/screens/` (layout, type, colours, square corners).
