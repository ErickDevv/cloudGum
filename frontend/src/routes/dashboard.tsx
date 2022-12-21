const route = import.meta.env.VITE_URL

const dashboard = () => {
    return <>
        <div className="App">
            <form action={route + "/upload"} method="post" encType="multipart/form-data">
                <input type="file" name="file" />
                <input type="submit" value="Upload" />
            </form>
        </div>
    </>
}

export default dashboard