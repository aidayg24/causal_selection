// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex1/Main/";


// All question screens as plain data
const Ex1TrialsDis = [
  {
    cardsImg: `${BASE_URL}instrument1Cards.jpg`,
    playImg: `${BASE_URL}instrument1Play.jpg`,
    q1: "I chose a good mix of cards for my deck.",
    q2: "I drew the violin card.",
    q3: "Bob chose a bad mix of cards for his deck.",
    q4: "Bob drew the guitar card.",
    statement: "I won because ",
    tag: "instrument1"
  },
  {
    cardsImg: `${BASE_URL}superhero1Cards.jpg`,
    playImg: `${BASE_URL}superhero1Play.jpg`,
    q1: "I chose a bad mix of cards for my deck.",
    q2: "I drew the Spider-Man card.",
    q3: "Bob chose a good mix of cards for his deck.",
    q4: "Bob drew the Joker card.",
    statement: "I lost because ",
    tag: "superhero1"
  }
];

export default Ex1TrialsDis;
