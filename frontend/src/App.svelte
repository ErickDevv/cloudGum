<script>
const ip = ''
const action = `http://${ip}:5050/upload`
</script>

<main>
  <form 

  href='uploadForm' 
  id='uploadForm' 
  action={action}
  method='post' 
  encType="multipart/form-data">
    <input type="file" name="sampleFile" />
    <input type='submit' value='Upload!' />
</form> 
</main>

<style>
</style>
