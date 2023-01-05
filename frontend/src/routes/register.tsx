import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { Link } from "react-router-dom"

const route = import.meta.env.VITE_URL

const Register = () => {

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
        <div className="lrcontainer">
            <form className="lrform" action="" onSubmit={e => e.preventDefault()}>
                <h1>Register</h1>
                <input type="text" placeholder="Username" className='lrinput' />
                <input type="password" placeholder="Password" className='lrpassword lrinput' />
                <button className="lrbutton" type="submit">Register</button>
                <p>Already have an account? <Link to="/">Login</Link></p>
            </form>
        </div>
    </>
}


export default Register