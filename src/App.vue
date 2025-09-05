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
  Well done on the practice round! Now we can begin the main experiment.<br/><br/>

  In this experiment, <strong>Charlie</strong> and <strong>Bob</strong> are playing a game.  
  Each of them can take one of two possible actions.
  <br/> Charlie has a superpower that he can choose to use it or not, <br/>
  and Bob can choose to drink beer during the game or not.<br/>  

  For each question, you will see a short report showing:<br/>  
  - what actions the players chose, and  <br/>  
  - a one-sentence summary of the outcome. <br/>   

  After the report, you will be asked questions about the game.<br/><br/>

  <strong>Please answer according to your own judgment.</strong>  
  There are no right or wrong answers.  <br/>  

  Some scenarios may look very similar, but small details can be important.    
  It is also perfectly fine if you give similar answers across different questions.<br/><br/>

  Let’s get started!
</InstructionScreen>
<!-- switched to experiment 2 because I think it is more informative -->
<!-- Q1, 2 point for win, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image, you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/instrumentRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/instrumentPlay.jpg" alt="player A cause win game">

    <p><strong>How much do you agree with the following statements?</strong></p>
        <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q2, 2 point for win, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superpowerPlay.jpg" alt="player B cause win game">
       <p><strong>How much do you agree with the following statements?</strong></p>
       <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q3, 2 point for win, lost, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/studyRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/studyPlay.jpg" alt="player A cause lost game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q4, 2 point for win,lost, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/gameRule.jpg" alt="2 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/gamePlay.jpg" alt="player B caused lost  game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q5, at least 1 point for win, superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/drugRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/drugPlay.jpg" alt="player B cause win game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>


<!-- Q6, at least 1 point for win, drink is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/matrixRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/matrixPlay.jpg" alt="player A caused win game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q7, at least 1 point for win, lost,superpower is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/foodRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/foodPlay.jpg" alt="player A cause lost game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
        :response.sync="$magpie.measurements.BNorm"
        />
       
        <button @click="$magpie.saveAndNextScreen()">Next Report</button>
       
    </Slide>
</Screen>

<!-- Q8, at least 1 point for win, lost,drunk is the cause -->
  <Screen>
  
    <Slide>
        <p>In the following image you can see the rules and the points of each move</p>
        <img src="https://aidayg24.github.io/causal_selection/images/main/superheroRule.jpg" alt="1 point Rule">
    
    <img src="https://aidayg24.github.io/causal_selection/images/main/superheroPlay.jpg" alt="player B cause lost game">
        <p><strong>How much do you agree with the following statements?</strong></p>
      <p>1. Charlie normally uses his superpower in the games.</p>
        <RatingInput
          left="Strongly disagree"
          right="Strongly agree"
          :response.sync="$magpie.measurements.ANorm"
        />

        <p>2. Bob normally drinks beer during the games.</p>
        <RatingInput
        left="Strongly disagree"
        right="Strongly agree"
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

