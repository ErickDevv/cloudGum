import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { Link } from "react-router-dom"

const Register = () => {

    const [user, setUser] = useState('')
    const [password, setPassword] = useState('')

    const navigate = useNavigate()

    const handleSubmit = () => {
        fetch(`/register`, {
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
                    ) : alert(data.message  )
                })
            }
            )

            
    }



    return <>
        <div className="lrcontainer">
            <form className="lrform" action="" onSubmit={e => e.preventDefault()}>
                <h1>Register</h1>
                <input type="text" placeholder="Username" className='register_user lrinput' onChange={() => {
                    setUser((document.querySelector('.register_user') as HTMLInputElement).value)
                }} />
                <input type="password" placeholder="Password" className='register_password lrpassword lrinput' onChange={() => {
                    setPassword((document.querySelector('.register_password') as HTMLInputElement).value)
                }} />
                <button className="lrbutton" type="submit" onClick={handleSubmit}>Register</button>
                <p>Already have an account? <Link to="/">Login</Link></p>
            </form>
        </div>
    </>
}


export default Register