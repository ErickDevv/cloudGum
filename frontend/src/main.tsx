import React from 'react'
import ReactDOM from 'react-dom/client'
import Root from './routes/root'
import Register from './routes/register'
import Dashboard from './routes/dashboard'
import './index.css'

import { createBrowserRouter, RouterProvider } from 'react-router-dom'

const router = createBrowserRouter([
  {
    path: '/',
    element: <Root/>,
  },
  {
    path: '/register',
    element: <Register />,

  },
  {
    path: '/dashboard',
    element: <Dashboard />,
  }
])

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
)
