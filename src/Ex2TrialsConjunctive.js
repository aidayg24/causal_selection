// Define the fixed part of the URL once
const BASE_URL = "https://aidayg24.github.io/causal_selection/images/Ex2/main/";

// All question screens as plain data
const Ex2TrialsConj = [
  {
    playImg: `${BASE_URL}instrumentPlay.jpg`,
    aliceImg: `${BASE_URL}instrumentAlice.jpg`,
    q1: "1. How many violin cards does Alice have?",
    q2: "2. How many guitar cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of violin cards as Bob has guitar cards?",
    tag: "instrument"
  },
  {
    playImg: `${BASE_URL}superpowerPlay.jpg`,
    aliceImg: `${BASE_URL}superpowerAlice.jpg`,
    q1: "1. How many superpower cards does Alice have?",
    q2: "2. How many beer cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of superpower cards as Bob has beer cards?",
    tag: "superpower"
  },
  {
    playImg: `${BASE_URL}studyPlay.jpg`,
    aliceImg: `${BASE_URL}studyAlice.jpg`,
    q1: "1. How many history cards does Alice have?",
    q2: "2. How many biology cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of history cards as Bob has biology cards?",
    tag: "study"
  },
  {
    playImg: `${BASE_URL}gamePlay.jpg`,
    aliceImg: `${BASE_URL}gameAlice.jpg`,
    q1: "1. How many party cards does Alice have?",
    q2: "2. How many study cards does Bob have?",
    q3: "3. Does Alice have more, fewer, or the same number of party cards as Bob has study cards?",
    tag: "game"
  }
];

export default Ex2TrialsConj;
