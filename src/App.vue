<template>
  <div>
    <div id="quote-section">
      <h4>{{ quote }}</h4>
    </div>
    <SimpleDocViewer id="resume"/>
  </div>
</template>

<script>
import SimpleDocViewer from './components/SimpleDocViewer.vue'
import axios from 'axios';

export default {
  name: 'App',
  components: {
    SimpleDocViewer
  },
  data() {
    return {
      quote: ""
    }
  },
  mounted: function () {
    this.randomQuote();
  },
  methods: {
    randomQuote: function () {
      console.log('getting new quote');
      axios.get('https://quotable.io/random').then((r) => {
        this.quote = r.data.content
      });
    }
  }
}
</script>

<style>
body {
  overflow: hidden;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}
#quote-section {
  display: inline-block;
}
#resume {
  width: 100vw;
  height: 100vh;
}
</style>
