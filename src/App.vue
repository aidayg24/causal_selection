<template>
  <Experiment title="magpie demo">
    <InstructionScreen :title="'Welcome'">
      Thank you for participating in this experiment! It should take no more than 15 minutes to complete.
      <br/>
      
Before starting the main tasks, you will practice with a small trial.

In this trial, you will read short reports about an imaginary game. After each report, you will be asked questions about the
game. 
    </InstructionScreen>

<!-- , trial -->
<Screen>
  <p>
    Alice and Bob are playing a small game.<br/>
     Alice has a coin which has a yellow and a red side, and Bob has a normal coin with head and tail sides.
    <br/>
    Alice earns 1 point if her coin comes yellow; otherwise, Bob earns 1 point.<br/>
    Alice earns 1 point if Bob's coin comes head; otherwise, Bob earns 1 point<br/>
    For a player to win, they need <b>exactly 2 points.</b>
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        qud="Alice's coin comes yellow, Bob's coin comes tail."
        :feedbackTime="3500" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'No one'">Correct! let's go to next one.</p>
        <p v-else>Incorrect, Alice has 1 point and Bob too, but for winning they need exactly 2 points.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<Screen>
  <p>
    Still the same game as previouse one;<br/>
    Alice earns 1 point if her coin comes yellow; otherwise, Bob earns 1 point.<br/>
    Alice earns 1 point if Bob's coin comes head; otherwise, Bob earns 1 point<br/>
    For a player to win, they need <b>exactly 2 points.</b>
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        qud="Alice's coin comes yellow, Bob's coin comes head."
        :feedbackTime="3500" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'Alice'">Correct! let's go to next one.</p>
        <p v-else>Incorrect, Alice has 2 point and Bob 0, and for winning they need exactly 2 points.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<Screen>
  <p>
    Now, a small change in the rules;<br/>
    Alice earns 1 point if her coin comes yellow; otherwise, Bob earns 1 point.<br/>
    Alice earns 1 point if Bob's coin comes head; otherwise, Bob earns 1 point<br/>
    For a player to win, they need <b>at least 1 point.</b>
  </p>
  <ForcedChoiceScreen
        :options="['Alice', 'Bob', 'No one']"
        question="Who will win?"
        qud="Alice's coin comes red, Bob's coin comes tail."
        :feedbackTime="3500" >

  <template #feedback>
        <p v-if="$magpie.measurements.response === 'Bob'">Correct!</p>
        <p v-else>Incorrect, Alice has 0 point and Bob 2, and for winning they need at least 1 point.</p>
    </template>
      
  </ForcedChoiceScreen>
</Screen>

<InstructionScreen :title="'Instruction'">
      Well done in the trial round! Now we can start the main experiment!<br/>
      In this experiment, similar to trial, you will read short reports about an imaginary game played in an
imaginary country. After each report, you will be asked questions about the
game. 
<br/>Please answer each question according to your own judgment; there are
no right or wrong answers.<br/>
Some scenarios may look similar, but pay close attention: they can differ in small
but important details. Please pay extra attention to the <b>bold</b> parts. You may also find that you give similar answers across
different questions, which is completely fine.
<br/>
Let's start.
    </InstructionScreen>

<!-- Q1, positive, abnormal cause -->
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
<!-- Q2, positive normal cause -->
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

<!-- Q3, negative, normal cause -->
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
<!-- Q4, negative, abnormal cause -->
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

