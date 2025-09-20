<template>
  <Experiment title="Experiment">
    <!-- Experiment 1 -->
    <InstructionScreen :title="'Welcome'">
      <p><strong>Welcome, and thank you for participating!</strong></p>

      <p>
        In this experiment, you will answer questions about the outcome of an
        <em>Icon Card Game</em>. First, you will read instructions explaining how the
        game works. Then you will answer a few warm-up questions to ensure the game
        is clear. After that, you will proceed to the main part of the experiment.
        <br>
        <br>
        Now let’s begin with the game instructions.
      </p>
    </InstructionScreen>
  
    <InstructionScreen :title="'Instructions'">
      <p>
      Alice and Bob are playing the "Icon Card Game".  
      Each player receives a <strong>deck of 10 cards</strong>, 
      composed of <strong>two types of icons</strong>.  
      Each player’s deck contains a <strong>different pair of icons</strong> 
      (i.e., Alice’s two icon types are not the same as Bob’s).<br>
      The <strong>number of each icon in each deck is determined randomly</strong>, 
      and <strong>both players know the exact composition of both decks</strong>.
      The deck is assembled, shuffled, and placed face-down in front of them.
    </p>
      <img src="https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image1.jpg" alt="cards and icons">
    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>
        A point system is then assigned <em><strong>randomly</strong></em> to the icons.<br/>
        In each deck, <strong>one icon gives Alice one point, and the other icon gives Bob one point.</strong><br/>
        For simplicity, only the icon that gives <em>Alice</em> a point is shown. The other icon automatically counts for Bob.
        Then the <strong>winning condition for Alice is presented</strong>.
      </p>
      <img
        :src="condition === 'conjunctive'
          ? 'https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image2_2.jpg'
          : 'https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image2_atleast1.jpg'"
        alt="cards and icons"
      />
    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>
        Then both players draw one card at random from their own deck at the 
        same time. You will then be told:
        </p>
        <ul>
          <li>which cards the players drew, and</li>
          <li>Alice's number of points</li>
        </ul>
        <p>
          Your task is to answer some questions about the game, based on the players’ deck choices and the winning rules of the game.
        </p>
        <p>
          <strong>Please answer according to your own judgment.</strong> There are no right or wrong answers.
        </p>
        <p>
          Before we start the experiment, let’s do a quick warm-up to ensure the instructions are clear.
      </p>


      <img src="https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image3.jpg" alt="cards and icons">
    </InstructionScreen>

    <!-- warm-up knowledge check -->
    <Screen>
      <img src="https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image2.jpg" alt="cards and icons">

      <ForcedChoiceScreen
          :question="`Is it possible that Bob draws a violin card from his deck?`"
          :options="['Yes', 'No', 'I am not sure']"
          :feedbackTime="-1" >

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'No'" class="feedback correct">
            Correct!<br/>
          </p>
          <!-- 'I am not sure' branch -->
          <p v-else-if="$magpie.measurements.response === 'I am not sure'" class="feedback unsure">
            See Below!<br/>
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              Each deck is made up of
              only two types of icons. Each player has a <strong>different pair of icons</strong>
              in their deck.<br>
            <span> Let's go to the next one.</span>
            </p>
          </p>
          <button @click="$magpie.nextScreen()">Ok</button>
        </template>

      </ForcedChoiceScreen>
    </Screen>

    <Screen>
      <img src="https://aidayg24.github.io/causal_selection/images/Ex1/Instruction/image2_2.jpg" alt="cards and icons">

      <ForcedChoiceScreen
          :question="`Here, can Alice win if she draws a saxophone card?`"
          :options="['Yes', 'No', 'I am not sure']" 
          :feedbackTime="-1">

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'No'" class="feedback correct">
            Correct!<br/>
          </p>
          <!-- 'I am not sure' branch -->
          <p v-else-if="$magpie.measurements.response === 'I am not sure'" class="feedback unsure">
            See Below!<br/>
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              To win, Alice needs exactly two points.<br/>
              A saxophone card gives Bob 1 point and does not give any points to Alice.<br/>
              Even if Bob draws a guitar card, it will only give one point to Alice, and she still cannot win.
              <br>
              <span> Let's go to the next one.</span>
            </p>
          </p>
          <button @click="$magpie.nextScreen()">Ok</button>
        </template>
      </ForcedChoiceScreen>
    </Screen>

    <Screen>
      <ForcedChoiceScreen
          :question="`Does Alice know how many guitar cards Bob has in his deck?`"
          :options="['Yes', 'No', 'I am not sure']"
          :feedbackTime="-1" >

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'Yes'" class="feedback correct">
            Correct!
          </p>
          <!-- 'I am not sure' branch -->
          <p v-else-if="$magpie.measurements.response === 'I am not sure'" class="feedback unsure">
            See Below!<br/>
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              <strong>Both players know the exact number of each icon in every deck.</strong> 
              <br/>
              <span> Let's start the experiment!</span>
            </p>
          </p>
          <button @click="$magpie.nextScreen()">Ok</button>
        </template>
      </ForcedChoiceScreen>
    </Screen>

    <!-- main experiment 1 -->
    <template v-for="(t, i) in Ex1TrialsShuffled">
      <Screen :key="i">
        <Slide>
          <img :src="t.cardsImg" class="card-img" alt="card image" />
          <img :src="t.playImg" class="play-img" alt="play image" />
          <p><strong><em>
            Imagine you are Alice. Given the rules of the game and its outcome, 
            which sentence would you prefer to say first?
          </em></strong></p>

        <ForcedChoiceScreen
          :options="[t.op1, t.op2]"
          :randomize="true"
          :question=  t.statement
          :responses.sync= "$magpie.measurements[t.tag]" />
        </Slide>
      </Screen>
    </template>



    <!-- Experiment 2 -->
    <!-- main experiment -->
    <template v-for="(t, i) in Ex2TrialsShuffled">
      <Screen :key="i">
        <Slide>
          <img :src="t.playImg" class="play-img" alt="play image" />
          <img :src="t.aliceImg" class="alice-img" alt="Alice image" />
          <p><strong><em>
            Given the rules of the game, the players’ knowledge about the proportion of each icon in their decks, 
            and what Alice said:
          </em></strong></p>

          <p><strong>{{ t.q1 }}</strong></p>
          <MultipleChoiceInput 
          orientation="horizontal"
          :options="['less than 5', '5', 'more than 5']"
          :response.sync="$magpie.measurements['ANorm_' + t.tag]" />

          <p><strong>{{ t.q2 }}</strong></p>
          <MultipleChoiceInput 
          orientation="horizontal"
          :options="['less than 5', '5', 'more than 5']"
          :response.sync="$magpie.measurements['BNorm_' + t.tag]" />

          <!-- Q3 only if both are 'less than 5' OR both are 'more than 5' -->
          <template v-if="isCompareNeeded(t)">
            <p><strong>{{ t.q3 }}</strong></p>
            <MultipleChoiceInput 
              orientation="horizontal"
              :options="['fewer', 'same number', 'more']" 
              :response.sync="$magpie.measurements['compare_' + t.tag]"
            />
          </template>

          <button
            :disabled="$magpie.measurements['ANorm_' + t.tag] === undefined
                    || $magpie.measurements['BNorm_' + t.tag] === undefined
                    || (isCompareNeeded(t) && !$magpie.measurements['compare_' + t.tag])"
            @click="$magpie.saveAndNextScreen()">Next</button>
        </Slide>
      </Screen>
    </template>


    <PostTestScreen />
    <SubmitResultsScreen />
  </Experiment>
</template>

<style scoped>
  button:disabled {
    background-color: #ccc;   /* gray background */
    color: #666;              /* dimmed text */
    cursor: not-allowed;      /* "forbidden" cursor */
    opacity: 0.6;             /* slightly transparent */
  }
  .feedback {
    font-weight: bold;
    text-align: center;
    margin: 1em 0;
  }

  .feedback.correct {
    color: green;
    font-size: 2em; /* super big */
  }
  .feedback.unsure {
    color: #E8CC0E;
    font-size: 2em; /* super big */
  }

  .feedback.incorrect {
    color: red;
    font-size: 2em; /* super big */
  }
  .play-img {
    width: 1800px;
    /* height: 845px; */
    object-fit: contain; /* scale proportionally, no stretching */
  }
  .alice-img {
    width: 700px;
    /* height: 400px;       */
    object-fit: contain; /* scale proportionally, no stretching */
  }
  .card-img {
    width: 700px;
    /* height: 400px;       */
    object-fit: contain; /* scale proportionally, no stretching */
  }
</style>


<script>
import _ from 'lodash';
import Ex1TrialsConj from './Ex1TrialsConjunctive.js';
import Ex1TrialsDis from './Ex1TrialsDisjunctive.js';
import Ex2TrialsConj from './Ex2TrialsConjunctive.js';
import Ex2TrialsDis from './Ex2TrialsDisjunctive.js';

export default {
  name: "App",
  data() {
    // Randomly assign once when the component is created
    const condition = Math.random() < 0.5 ? 'conjunctive' : 'disjunctive';

    return {
      condition,   // for logging if needed

      // For Experiment 1
      Ex1TrialsShuffled: _.shuffle(
        condition === 'conjunctive' ? Ex1TrialsConj : Ex1TrialsDis
      ),

      // For Experiment 2
      Ex2TrialsShuffled: _.shuffle(
        condition === 'conjunctive' ? Ex2TrialsConj : Ex2TrialsDis
      )
    };
  },

  methods: {

    isCompareNeeded(t) {
      const a = this.$magpie.measurements['ANorm_' + t.tag];
      const b = this.$magpie.measurements['BNorm_' + t.tag];
      if (!a || !b) return false;
      return (
        (a === 'less than 5' && b === 'less than 5') ||
        (a === 'more than 5' && b === 'more than 5')
      );
    },

    // Copy question texts + answers into top-level fields so they appear in CSV
    finalizeMatrix(t) {
      const qa = this.$magpie.measurements[`${t.tag}_answers`] || {};
      this.$magpie.measurements[`${t.tag}_questions_json`] =
      JSON.stringify([t.q1, t.q2, t.q3, t.q4]);

      this.$magpie.saveAndNextScreen();
    }
  }
};
</script>


