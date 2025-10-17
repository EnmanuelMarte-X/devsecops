import React, { useEffect, useState } from 'react'


export default function App(){
const [msg, setMsg] = useState('cargando...')


useEffect(() => {
fetch('/api/hello')
.then(r => r.json())
.then(d => setMsg(d.message))
.catch(() => setMsg('No pude conectar con el backend'))
}, [])


return (
<main style={{fontFamily:'system-ui', padding: 24}}>
<h1>React + Go</h1>
<p>Respuesta del backend:</p>
<pre style={{background:'#f6f8fa', padding:12, borderRadius:8}}>{msg}</pre>
</main>
)
}