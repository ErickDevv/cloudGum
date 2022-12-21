import { useState } from "react"
import { useNavigate } from "react-router-dom"

const route = import.meta.env.VITE_URL

const register = () => {

    const [user, setUser] = useState('')
    const [password, setPassword] = useState('')

    const navigate = useNavigate()

    const handleSubmit = () => {
        fetch(`${route}/register`, {
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
        <h1>Register</h1>
        <form action="" onSubmit={e => e.preventDefault()}>
            <input type="text" placeholder="Username" className='user' />
            <input type="password" placeholder="Password" className='password' />
            <button type="submit">Register</button>
        </form>
    </>
}


export default register