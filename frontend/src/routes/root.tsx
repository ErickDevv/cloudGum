import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Link } from 'react-router-dom'

import './login_register.css'

const route = import.meta.env.VITE_URL

const Root = () => {
    const [user, setUser] = useState('')
    const [password, setPassword] = useState('')

    const navigate = useNavigate()

    const handleSubmit = () => {
        console.log(route);

        fetch(`${route}/login`, {
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
        <div className='lrcontainer'>

            <form className='lrform' action="" onSubmit={e => e.preventDefault()}>
            <h1>Login</h1>
                <input type="text" placeholder="Username" className='lrinput' onChange={() => {
                    setUser((document.querySelector('.user') as HTMLInputElement).value)
                }} />
                <input type="password" placeholder="Password" className='lrpassword lrinput' onChange={() => {
                    setPassword((document.querySelector('.password') as HTMLInputElement).value)
                }} />
                <button className='lrbutton' type="submit" onClick={handleSubmit}>Login</button>
                <p>Don't have an account? <Link to="/register">Register</Link></p>
            </form>
        </div>
    </>
}

export default Root