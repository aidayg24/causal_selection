// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex1/Main/";


// All question screens as plain data
const Ex1TrialsConj = [
  {
    playImg: `${BASE_URL}matrix2.jpg`,
    op1: "I drew the red pill card.",
    op2: "Bob drew the eat card.",
    statement: "I won because ",
    tag: "matrix2"
  },
  {
    playImg: `${BASE_URL}superhero2.jpg`,
    op1: "I drew the Spider-Man card.",
    op2: "Bob drew the Joker card.",
    statement: "I lost because ",
    tag: "superhero2"
  },
  {
    playImg: `${BASE_URL}drug2.jpg`,
    op1: "I drew the pill card.",
    op2: "Bob drew the bubble tea card.",
    statement: "I won because ",
    tag: "drug2"
  },
  {
    playImg: `${BASE_URL}food2.jpg`,
    op1: "I drew the salad card.",
    op2: "Bob drew the lollipop card.",
    statement: "I lost because ",
    tag: "food2"
  }
];

export default Ex1TrialsConj;
