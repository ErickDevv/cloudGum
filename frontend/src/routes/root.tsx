
import { useState } from 'react'
import { useNavigate } from 'react-router-dom'

const Root = () => {
    const [user, setUser] = useState('')
    const [password, setPassword] = useState('')

    const navigate = useNavigate()

    const handleSubmit = () => {
        fetch('', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                user,
                password,
            })
        })
            .then((res) => { res.ok ? navigate('/dashboard') : alert('Invalid credentials') })
    }

    return <>
        <h1>Login</h1>
        <form action="" onSubmit={e => e.preventDefault()}>
            <input type="text" placeholder="Username" className='user' onChange={() => {
                setUser((document.querySelector('.user') as HTMLInputElement).value)
            }} />
            <input type="password" placeholder="Password" className='password' onChange={() => {
                setPassword((document.querySelector('.password') as HTMLInputElement).value)
            }} />
            <button type="submit" onClick={handleSubmit}>Login</button>
        </form>
    </>
}

export default Root