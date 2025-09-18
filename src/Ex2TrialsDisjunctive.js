// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex2/main/";

// All question screens as plain data
const Ex2TrialsDis = [
  {
    playImg: `${BASE_URL}drugPlay.jpg`,
    aliceImg: `${BASE_URL}drugAlice.jpg`,
    q1: "1. How many pill cards does Alice have?",
    q2: "2. How many beer cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of pill cards as Bob has beer cards?",
    tag: "drug"
  },
  {
    playImg: `${BASE_URL}matrixPlay.jpg`,
    aliceImg: `${BASE_URL}matrixAlice.jpg`,
    q1: "1. How many red pill cards does Alice have?",
    q2: "2. How many eat cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of red pill cards as Bob has eat cards?",
    tag: "matrix"
  },
  {
    playImg: `${BASE_URL}foodPlay.jpg`,
    aliceImg: `${BASE_URL}foodAlice.jpg`,
    q1: "1. How many salad cards does Alice have?",
    q2: "2. How many popcorn cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of salad cards as Bob has popcorn cards?",
    tag: "food"
  },
  {
    playImg: `${BASE_URL}superheroPlay.jpg`,
    aliceImg: `${BASE_URL}superheroAlice.jpg`,
    q1: "1. How many spiderman cards does Alice have?",
    q2: "2. How many joker cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of spiderman cards as Bob has joker cards?",
    tag: "superhero"
  }
];

export default Ex2TrialsDis;
