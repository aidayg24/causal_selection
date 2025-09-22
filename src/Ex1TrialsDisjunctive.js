// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex1/Main/";


// All question screens as plain data
const Ex1TrialsDis = [
  {
    playImg: `${BASE_URL}instrument1Play.jpg`,
    op1: "I drew the violin card.",
    op2: "Bob drew the guitar card.",
    statement: "I won because ",
    tag: "instrument1"
  },
  {
    playImg: `${BASE_URL}superpower1Play.jpg`,
    op1: "I drew the office worker card.",
    op2: "Bob drew the bubble tea card.",
    statement: "I lost because ",
    tag: "superpower1"
  },
  {
    playImg: `${BASE_URL}study1.jpg`,
    op1: "I drew the math card.",
    op2: "Bob drew the biology card.",
    statement: "I won because ",
    tag: "study1"
  },
  {
    playImg: `${BASE_URL}game1.jpg`,
    op1: "I drew the party card.",
    op2: "Bob drew the game card.",
    statement: "I lost because ",
    tag: "game1"
  }
];

export default Ex1TrialsDis;
