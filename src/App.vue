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
    Alice and Bob are playing a small game. Both have two cards, and they can pick one of them. In the image below, you can see the points for each move:<br/>
    <img src="https://aidayg24.github.io/causal_selection/images/training/2point.jpg" alt="2 point Rule">
    <strong>If in the game they played the following: </strong>
    <img src="https://aidayg24.github.io/causal_selection/images/training/yellow_tail.jpg" alt="yellow tail game">
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        :feedbackTime="2000" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'No one'">Correct! Let's go to the next one.</p>
        <p v-else>Incorrect, Alice has 1 point and Bob too, but for winning, they need exactly 2 points.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<Screen>
  <p>
    Still the same game as the previous one;<br/>
    <img src="https://aidayg24.github.io/causal_selection/images/training/2point.jpg" alt="2 point Rule">
    <strong>If in the game they played the following: </strong>
    <img src="https://aidayg24.github.io/causal_selection/images/training/yellow_head.jpg" alt="yellow head game">
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        :feedbackTime="2000" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'Alice'">Correct! Let's go to the next one.</p>
        <p v-else>Incorrect, Alice has 2 points and Bob 0, and for winning, they need exactly 2 points.</p>
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
        <p v-else>Incorrect, Alice has 0 points and Bob 2, and for winning, they need at least 1 point.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<InstructionScreen :title="'Instructions'">
  Well done on the practice round! Now we can begin the main experiment.<br/><br/>

In this part, two players are taking part in a <em>“Choosing Game.”</em>  
Each player has two possible options, and they must choose one of them.  
The options for each player will be explained in the scenario.<br/><br/>

For each question, you will be shown a short report that tells you: <br/>  
- which options the players chose, and <br/>  
- a one-sentence explanation of what caused the result of the game. <br/><br/>

<strong>Your task: Imagine the players had played the same game 10 times before.  
Based on the report, estimate how often each player would typically choose their options. </strong> <br/><br/>

<strong>Please answer according to your own judgment.</strong>  
There are no right or wrong answers. <br/><br/>

Let’s get started!
</InstructionScreen>
<!-- switched to experiment 2 because I think it is more informative -->
<!-- Q1, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/InstrumentRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/instrumentPlay.jpg" alt="player A cause win game">

    <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Alice have chosen the violin?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Max have chosen the guitar?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q2, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerPlay.jpg" alt="player B cause win game">
       
     <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Charlie have chosen the superpower?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Bob have chosen the beer?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q3, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/studyRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/studyPlay.jpg" alt="player A cause lost game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Eli have chosen history?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Nana have chosen biology?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q4, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/gameRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/gamePlay.jpg" alt="player B caused lost  game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Mia have chosen to party?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Bob have chosen to study?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q5, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/drugRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/drugPlay.jpg" alt="player B cause win game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Zoe have chosen to take the pill?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Tom have chosen the beer?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q6, -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/matrixRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/matrixPlay.jpg" alt="player A caused win game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Neo have chosen the red pill?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Alice have chosen to eat?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q7,-->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/foodRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/foodPlay.jpg" alt="player A cause lost game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Ben have chosen the salad?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Lia have chosen the popcorn?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q8,  -->
  <Screen>
  
    <Slide>
        <p>Look at the image below to see the rules and how points are assigned.</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superheroRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superheroPlay.jpg" alt="player B cause lost game">
        <p><strong>If the players had played this game 10 times before,</strong></p>
        <p><strong>1.  How many times would Leo have chosen Spider-Man?</strong></p>
        <RatingInput
          :count="10"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p><strong> 2. How many times would Sam have chosen the Joker?</strong></p>
        <RatingInput
          :count="10"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!--
 Q1, positive, abnormal cause 
<Screen>
  
    <Slide>
        Last night was the 11th game night event in PlayLand. <br/>Two players, Charlie and Bob, took part.
        The general rules for the games:
        <br/>
        ●​ Charlie earns 1 point if he uses his superpower; otherwise, Bob earns 1 point.
        <br/>●​ Charlie earns 1 point if Bob drank last night; otherwise, Bob earns 1 point.
        <br/>We also know that in PlayLand:<br/>
        ●​ Bob got drunk the night before the game in 9 out of 10 previous games<br/>
        ●​ Charlie used his superpower in 2 out of 10 games
        <br/>
                If in this game,<br/><b>
        ● Bob got drunk the night before and<br/>
        ● Charlie used his superpower<br/> </b>

        And this is the final report of the game:<br/>
        Charlie won <b>because he used his superpower</b> <br/>
        How much do you agree that each of the following scoring rules was used last night?<br/>


        <p>1. To win, the player needs exactly 2 points.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.twopoint"
        />

        <p>2. To win, the player needs at least 1 point.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.leastone"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>
 Q2, positive normal cause
<Screen>
    <Slide>
        Last night was the 11th game night event in PlayLand. <br/>Two players, Charlie and Bob, took part.
        The general rules for the games:
        <br/>
        ●​ Charlie earns 1 point if he uses his superpower; otherwise, Bob earns 1 point.
        <br/>●​ Charlie earns 1 point if Bob drank last night; otherwise, Bob earns 1 point.
        <br/>We also know that in PlayLand:<br/>
        ●​ Bob got drunk the night before the game in 9 out of 10 previous games<br/>
        ●​ Charlie used his superpower in 2 out of 10 games
        <br/>
                If in this game,<br/><b>
        ● Bob got drunk the night before and<br/>
        ● Charlie used his superpower<br/>
        </b>

        And this is the final report of the game:<br/>
        Charlie won <b>because Bob drank the night before the game </b><br/>
        How much do you agree that each of the following scoring rules was used last night?<br/>


        <p>1. To win, the player needs exactly 2 points.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.twopoint"
        />

        <p>2. To win, the player needs at least 1 point.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.leastone"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

 Q3, negative, normal cause 
 <Screen>
    <Slide>
        Last night was the 11th game night event in PlayLand. <br/>Two players, Charlie and Bob, took part.
        The general rules for the games:
        <br/>
        ●​ Charlie earns 1 point if he uses his superpower; otherwise, Bob earns 1 point.
        <br/>●​ Charlie earns 1 point if Bob drank last night; otherwise, Bob earns 1 point.
        <br/>We also know that in PlayLand:<br/>
        ●​ Bob got drunk the night before the game in 9 out of 10 previous games<br/>
        ●​ Charlie used his superpower in 2 out of 10 games
        <br/>
                If in this game,<br/><b>
        ● Bob did not get drunk the night before<br/>
        ● Charlie did not use his superpower<br/>
        </b>

        And this is the final report of the game:<br/>
        Charlie lost <b>because he did not use his superpower</b><br/>
        How much do you agree that each of the following scoring rules was used last night?<br/>


        <p>1. To win, the player needs exactly 2 points.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.twopoint"
        />

        <p>2. To win, the player needs at least 1 point.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.leastone"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>
 Q4, negative, abnormal cause 
 <Screen>
    <Slide>
        Last night was the 11th game night event in PlayLand. <br/>Two players, Charlie and Bob, took part.
        The general rules for the games:
        <br/>
        ●​ Charlie earns 1 point if he uses his superpower; otherwise, Bob earns 1 point.
        <br/>●​ Charlie earns 1 point if Bob drank last night; otherwise, Bob earns 1 point.
        <br/>We also know that in PlayLand:<br/>
        ●​ Bob got drunk the night before the game in 9 out of 10 previous games<br/>
        ●​ Charlie used his superpower in 2 out of 10 games
        <br/>
                If in this game,<br/><b>
        ● Bob did not get drunk the night before<br/>
        ● Charlie did not use his superpower<br/>
        </b>

        And this is the final report of the game:<br/>
        Charlie lost <b>because Bob did not drink the night before the game</b><br/>
        How much do you agree that each of the following scoring rules was used last night?<br/>


        <p>1. To win, the player needs exactly 2 points.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.twopoint"
        />

        <p>2. To win, the player needs at least 1 point.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.leastone"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>
-->
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

