<template>
  <Experiment title="magpie demo">
    <InstructionScreen :title="'Welcome'">
  <p><strong>Welcome, and thank you for participating!</strong><br/>
  This experiment will take about <strong>20 minutes</strong> to complete.</p>

  <p>In this experiment, you will read about games between two players</p>

  <ul>
    <li>Each player can make certain moves.</li>
    <li>Depending on their moves, <strong>points are awarded</strong> </li>
    <li>Each game also has a <strong>win rule</strong>, which tells us how a player can win.</li>
  </ul>

  <p>You will be shown:</p>
  <ol>
    <li>The rules of the game </li>
    <li>What moves the players made</li>
    <li>The resulting points and outcome</li>
  </ol>

  <p>Based on this information, you will be asked to <strong>make judgments</strong> about the game.</p>

  <p>Before the main experiment begins, you will complete <strong>3 practice questions</strong> 
  to get familiar with the rules.</p>

  <p>👉 Click <strong>Next</strong> to start the trial questions!</p>
    </InstructionScreen>

<!-- , trial -->
<Screen>
  <p>
    Alice and Bob are playing a small game. Both have two cards and they can pick one of them. In the image below you can see the points for each move:<br/>
    <img src="https://aidayg24.github.io/causal_selection/images/training/2point.jpg" alt="2 point Rule">
    <strong>If in the game they played the following: </strong>
    <img src="https://aidayg24.github.io/causal_selection/images/training/yellow_tail.jpg" alt="yellow tail game">
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        :feedbackTime="2000" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'No one'">Correct! let's go to next one.</p>
        <p v-else>Incorrect, Alice has 1 point and Bob too, but for winning they need exactly 2 points.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<Screen>
  <p>
    Still the same game as previouse one;<br/>
    <img src="https://aidayg24.github.io/causal_selection/images/training/2point.jpg" alt="2 point Rule">
    <strong>If in the game they played the following: </strong>
    <img src="https://aidayg24.github.io/causal_selection/images/training/yellow_head.jpg" alt="yellow head game">
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        :feedbackTime="2000" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'Alice'">Correct! let's go to next one.</p>
        <p v-else>Incorrect, Alice has 2 point and Bob 0, and for winning they need exactly 2 points.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<Screen>
  <p>
    Now, a small change in the rules;<br/>
    <img src="https://aidayg24.github.io/causal_selection/images/training/atleast1point.jpg" alt="1 point Rule">
    <strong>If in the game they played the following: </strong>
    <img src="https://aidayg24.github.io/causal_selection/images/training/red_tail.jpg" alt="red tail game">
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        :feedbackTime="2000" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'Bob'">Correct!</p>
        <p v-else>Incorrect, Alice has 0 point and Bob 2, and for winning they need at least 1 point.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<InstructionScreen :title="'Instructions'">
  Well done on the practice round! Now we can begin the main experiment. <br/><br/>

In this part, two players are taking part in a <em>“Card Game.”</em>
Each player has a deck of 10 cards. Every deck contains only two types of emojis, and the players cannot see the emojis. The exact number of each emoji is unknown to them. <br/><br/>

In each round, both players draw one card at random. Then a short report will tell you: <br/>

which cards the players drew, and <br/>

one sentence from a Reporter, who knows all 20 cards, that explains who won and why. <br/><br/>

<strong>Your task: Based on the report, estimate how many of each emoji are in each player’s deck.</strong> <br/><br/>

<strong>Please answer according to your own judgment.</strong>
There are no right or wrong answers. <br/><br/>

Let’s get started!
</InstructionScreen>
<!-- switched to experiment 2 because I think it is more informative -->
<!-- Q1, 2 point for win, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/InstrumentRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/instrumentPlay.jpg" alt="player A cause win game">

        <p><strong>1. How many violin cards does Alice have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many guitar cards does Max have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q2, 2 point for win, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerPlay.jpg" alt="player B cause win game">
       
        <p><strong>1. How many superpower cards does Charlie have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many beer cards does Bob have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q3, 2 point for win, lost, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/studyRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/studyPlay.jpg" alt="player A cause lost game">

        <p><strong>1.  How many history cards does Eli have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many biology cards does Nana have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q4, 2 point for win,lost, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/gameRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/gamePlay.jpg" alt="player B caused lost  game">
        <p><strong>1.  How many party cards does Mia have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many study cards does Bob have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q5, at least 1 point for win, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/drugRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/drugPlay.jpg" alt="player B cause win game">
        <p><strong>1.  How many pill cards does Zoe have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many beer cards does Tom have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q6, at least 1 point for win, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/matrixRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/matrixPlay.jpg" alt="player A caused win game">
        <p><strong>1.  How many red pill cards does Neo have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many eat cards does Alice have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q7, at least 1 point for win, lost,superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/foodRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/foodPlay.jpg" alt="player A cause lost game">
        <p><strong>1. How many salad cards does Ben have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many popcorn cards does Lia have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q8, at least 1 point for win, lost,drunk is the cause -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and the report.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superheroRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superheroPlay.jpg" alt="player B cause lost game">
        <p><strong>1.  How many spiderman cards does Leo have?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many joker cards does Sam have?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<InstructionScreen :title="'Instructions'">
  Now the game center has created a new game with new players and new rules! <br/><br/>

In this game, each player builds their own deck of 10 cards. They must always choose 2 cards of one emoji and 8 cards of the other emoji. No other combinations are allowed. <br/><br/>

After the players set their decks, the cards are shuffled. Then a Judge, who does not know how the decks are divided, decides the point system. The Judge chooses which emoji will give points and which will not. <br/><br/>

Once this is done, each player flips one card. <br/><br/>

<strong>Your task: Based on what happens in the play, answer the questions that follow.</strong> <br/><br/>

Let’s go!
</InstructionScreen>
<Screen>
  
    <Slide>
        <p>Look at the image below to see the decks and the judge's point destribution and the play.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/secondExRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/secondExPlay.jpg" alt="player B cause lost game">
        <p><strong>Felix lost because: </strong></p>
        <Slide>
        <MultipleChoiceMatrixInput
            :options="['Strongly disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly agree']"
            :questions="[
              'He chose a bad mix of cards for his deck',
              'He turned over the Spider-Man card',
              'Carla chose a good mix of cards for her deck',
              'Carla turned over the Joker card',
              'The Judge gave points in a certain way'
            ]"
            :randomize="true"
            :responses.sync= "$magpie.measurements.responses"
        />
      </Slide>
        
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>

<script>
import _ from 'lodash';

export default {
  name: 'App',
  data() {
    return {};
  },
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  }
};
</script>

