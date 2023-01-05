import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Link } from 'react-router-dom'

import './login_register.css'

const Root = () => {
    const [user, setUser] = useState('')
    const [password, setPassword] = useState('')

    const navigate = useNavigate()

    const handleSubmit = () => {
        fetch(`/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                user,
                password,
            })
        })
            .then((res) => {
                res.json().then((data) => {
                    data.accessToken ? (
                        navigate('/dashboard'),
                        localStorage.setItem('token', data.accessToken),
                        user == "",
                        password == ""
                    ) : alert(data.message)
                })
            })
    }

    return <>
        <div className='lrcontainer'>
            <form className='lrform' action="" onSubmit={e => e.preventDefault()}>
                <h1>Login</h1>
                <input type="text" placeholder="Username" className='login_user lrinput' onChange={() => {
                    setUser((document.querySelector('.login_user') as HTMLInputElement).value)
                }} />
                <input type="password" placeholder="Password" className='login_password lrpassword lrinput' onChange={() => {
                    setPassword((document.querySelector('.login_password') as HTMLInputElement).value)
                }} />
                <button className='lrbutton' type="submit" onClick={handleSubmit}>Login</button>
                <p>Don't have an account? <Link to="/register">Register</Link></p>
            </form>
        </div>
    </>
}

export default Root