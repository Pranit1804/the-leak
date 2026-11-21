/// Round state machine phases (TECH_SPEC section 6).
enum RoundPhase {
  handout,
  questioning,
  whoGuessed,
  discussion,
  voting,
  reveal,
  done;

  static RoundPhase parse(String s) => RoundPhase.values.byName(s);
}
