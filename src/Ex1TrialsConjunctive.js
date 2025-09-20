// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex1/Main/";


// All question screens as plain data
const Ex1TrialsConj = [
  {
    cardsImg: `${BASE_URL}matrix2Cards.jpg`,
    playImg: `${BASE_URL}matrix2Play.jpg`,
    op1: "I drew the red pill card.",
    op2: "Bob drew the eat card.",
    statement: "I won because ",
    tag: "matrix2"
  },
  {
    cardsImg: `${BASE_URL}superhero2Cards.jpg`,
    playImg: `${BASE_URL}superhero2Play.jpg`,
    op1: "I drew the Spider-Man card.",
    op2: "Bob drew the Joker card.",
    statement: "I lost because ",
    tag: "superhero2"
  }
];

export default Ex1TrialsConj;
