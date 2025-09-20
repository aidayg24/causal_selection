// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex1/Main/";


// All question screens as plain data
const Ex1TrialsDis = [
  {
    cardsImg: `${BASE_URL}instrument1Cards.jpg`,
    playImg: `${BASE_URL}instrument1Play.jpg`,
    op1: "I drew the violin card.",
    op2: "Bob drew the guitar card.",
    statement: "I won because ",
    tag: "instrument1"
  },
  {
    cardsImg: `${BASE_URL}superpower1Cards.jpg`,
    playImg: `${BASE_URL}superpower1Play.jpg`,
    op1: "I drew the Office worker card.",
    op2: "Bob drew the bubble tea card.",
    statement: "I lost because ",
    tag: "superpower1"
  }
];

export default Ex1TrialsDis;
