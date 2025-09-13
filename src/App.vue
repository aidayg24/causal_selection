<template>
  <Experiment title="Experiment">
  
    <InstructionScreen :title="'Instructions'">
      <p><strong>Welcome, and thank you for participating!</strong></p>

      <p>
        In this experiment, you will answer questions about the outcome of an
        <em>"Icon Card Game"</em>. In this game, there are <strong>two players</strong>.
        Each player has a <strong>deck of 10 cards</strong>. Each deck is made up of
        only two types of icons. Each player has a <strong>different pair of icons</strong>
        in their deck. The exact number of each type of icon in both decks is
        <strong>unknown to the players</strong>.
      </p>

      <img src="https://aidayg24.github.io/causal_selection/images/instruction/icons.jpg" alt="cards and icons">

    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>
        Each card is worth one point, and the explanation under the icon shows which
        player gets the point if that card is drawn.
      </p>
      <img src="https://aidayg24.github.io/causal_selection/images/instruction/points.jpg" alt="points">

    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>Each game has its own winning condition based on points.</p>
      <img src="https://aidayg24.github.io/causal_selection/images/instruction/winningRule.jpg" alt="winning rule">

    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>In the game, both players draw one card at random from their own deck. You will then be told:
      <ul>
        <li>which cards the players drew, and</li>
        <li>each player's point</li>
      </ul>
      </p>

      <img src="https://aidayg24.github.io/causal_selection/images/instruction/play.jpg" alt="play">

    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>After the game, Yoda, <strong><em>who knows the exact number of each icon in every deck,</em></strong> makes a statement about the game.
      <br/> Your task is to answer some questions about the game, based on Yoda's knowledge and the statement, 
      and the winning rule of the game<br/>
      <p><strong>Please answer according to your own judgment.</strong> There are no right or wrong answers.</p>
      <p>
        Before we start the experiment, let’s do some quick warm-up questions to
        ensure the instructions are clear.
      </p>

      </p>

      <img src="https://aidayg24.github.io/causal_selection/images/instruction/Yoda.jpg" alt="Yoda">

    </InstructionScreen>

    <!-- warm-up knowledge check -->
    <Screen>
      <img src="https://aidayg24.github.io/causal_selection/images/instruction/icons.jpg" alt="cards and icons">

      <ForcedChoiceScreen
          :question="`Does Alice know how many violin cards she has and which cards are violin in her deck?`"
          :options="['Yes', 'No', 'I am not sure']" 
          :feedbackTime="-1">

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'No'" class="feedback correct">
            Correct!<br>
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              The exact number of each type of icon in both decks is
              <strong>unknown to the players</strong>.<br>
              <span> Let's go to the next one.</span>
            </p>
          </p>
          <button @click="$magpie.nextScreen()">Ok</button>
        </template>

      </ForcedChoiceScreen>
    </Screen>

    <Screen>
      <img src="https://aidayg24.github.io/causal_selection/images/instruction/icons.jpg" alt="cards and icons">

      <ForcedChoiceScreen
          :question="`Is it possible that Max draws a violin card from his deck?`"
          :options="['Yes', 'No', 'I am not sure']"
          :feedbackTime="-1" >

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'No'" class="feedback correct">
            Correct!<br/>
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
      <img src="https://aidayg24.github.io/causal_selection/images/instruction/winningRule.jpg" alt="winning rule">

      <ForcedChoiceScreen
          :question="`Here, can Alice win if she draws a saxophone card?`"
          :options="['Yes', 'No', 'I am not sure']" 
          :feedbackTime="-1">

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'No'" class="feedback correct">
            Correct!<br/>
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              To win, Alice needs exactly two points.<br/>
              A saxophone card gives Max 1 point and does not give any points to Alice.<br/>
              Even if Max draws a guitar card, it will only give one point to Alice, and she still cannot win.
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
          :question="`Does Yoda know how many guitar cards Max has in his deck?`"
          :options="['Yes', 'No', 'I am not sure']"
          :feedbackTime="-1" >

        <template #feedback>
          <p v-if="$magpie.measurements.response === 'Yes'" class="feedback correct">
            Correct!
          </p>
          <p v-else class="feedback incorrect">
            Incorrect!<br>
            <p>
              <strong>Yoda knows the exact number of each icon in every deck.</strong> 
              <br/>
              <span> Let's start the experiment!</span>
            </p>
          </p>
          <button @click="$magpie.nextScreen()">Ok</button>
        </template>
      </ForcedChoiceScreen>
    </Screen>

    <!-- main experiment -->
    <template v-for="(t, i) in trialsShuffled">
      <Screen :key="i">
        <Slide>
          <img :src="t.playImg" class="play-img" alt="play image" />
          <img :src="t.yodaImg" class="yoda-img" alt="Yoda image" />
          <p><strong><em>
            Given the rules of the game, the players’ uncertainty about the proportion of each icon in their decks, and what Yoda said:
          </em></strong></p>

          <p><strong>{{ t.q1 }}</strong></p>
          <RatingInput :count="10" 
          :response.sync="$magpie.measurements['ANorm_' + t.tag]" />

          <p><strong>{{ t.q2 }}</strong></p>
          <RatingInput :count="10" 
          :response.sync="$magpie.measurements['BNorm_' + t.tag]" />
          <button
            :disabled="$magpie.measurements['ANorm_' + t.tag] === undefined
                    || $magpie.measurements['BNorm_' + t.tag] === undefined"
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

  .feedback.incorrect {
    color: red;
    font-size: 2em; /* super big */
  }
  .play-img {
    width: 1800px;
    /* height: 845px; */
    object-fit: contain; /* scale proportionally, no stretching */
  }
  .yoda-img {
    width: 700px;
    /* height: 400px;       */
    object-fit: contain; /* scale proportionally, no stretching */
  }
</style>


<script>
import _ from 'lodash';
import trials from './trials.js';

export default {
  name: "App",
  data() {
    return {
      trialsShuffled: _.shuffle(trials)
    };
  }
};
</script>

