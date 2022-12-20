function App() {

  return (
    <div className="App">
      <form action="http://localhost:5050/upload" method="post" encType="multipart/form-data">
        <input type="file" name="file" />
        <input type="submit" value="Upload" />
      </form>

    </div>
  )
}

export default App
