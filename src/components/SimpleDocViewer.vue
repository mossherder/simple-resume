<template>
  <iframe id="frame" src="https://docs.google.com/gview?url=https://simpleresumeraccount.blob.core.windows.net/resume-blob/Mendez_Resume.docx&embedded=true"></iframe>
</template>
<script>

export default {
  name: 'SimpleDocViewer',
  components: {
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
#frame {
  width: 100%;
  height: 100%;
}
</style>
