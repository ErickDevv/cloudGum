import { useState, useEffect } from 'react'
import "./dashboard.css"

const Dashboard = () => {

    const [files, setFiles] = useState(["ddheuishduiodjoijdwokjdisoa s", "dsa"])
    const [file, setFile] = useState("")

    useEffect(() => {
        getFiles();
    }, files)

    const downloadFile = (fileName: string) => {
        fetch('/download', {
            method: 'POST',

            body: JSON.stringify({
                fileName: fileName
            }),
            //@ts-ignore
            headers: {
                "Content-Type": "application/json",
                "x-access-token": localStorage.getItem('token')
            }
        }).then(res => res.blob().then(res => {
            //download file
            const url = window.URL.createObjectURL(new Blob([res]));
            const link = document.createElement('a');
            link.href = url;
            link.setAttribute('download', fileName);
            document.body.appendChild(link);
            link.click();
        }))
    }

    const getFiles = () => {
        fetch('/getfiles', {
            //@ts-ignore
            headers: {
                "x-access-token": localStorage.getItem('token')
            }
        }).then(res => res.json().then(data => setFiles(data)))
    }


    const fileOnChange = (e: any) => {
        setFile(e.target.files[0])
    }

    const sendFile = () => {
        const formData = new FormData();
        formData.append('file', file);
        fetch('/upload', {
            method: 'POST',
            body: formData,
            //@ts-ignore
            headers: {
                "x-access-token": localStorage.getItem('token')
            }
        }).then(getFiles)
    }
    return <>
        <nav className='dashnav'>
            <h1>Dashboard</h1>
            <div className='dashupload'>
                <p>UPLOAD</p>
                <div className='dashinputcontainer'>
                    <input type="file" onChange={fileOnChange} />
                    <div className='dashuploadbuttons'>
                        <button className='dashuploadbutton' onClick={sendFile}>Send</button>
                        <button className='dashrefreshbutton' onClick={() => {
                            getFiles();
                        }}>Refresh</button>
                    </div>
                </div>
            </div>
        </nav>
        <div className='files'>
            {files.map((fileName: any) => {
                return <div className='file'>
                    <p className='filename'>{fileName}</p>
                    <button className='downloadbutton' onClick={() => downloadFile(fileName)}>Download</button>
                </div>
            })
            }
        </div>
    </>
}

export default Dashboard