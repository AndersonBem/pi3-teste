const btn = document.getElementById('btn');
const resultado = document.getElementById('resultado');

btn.addEventListener('click', async () => {
    try {
        const response = await fetch('http://127.0.0.1:7000/api/hello/');
        const data = await response.json();
        resultado.textContent = data.mensagem;
    } catch (error) {
        resultado.textContent = 'Erro ao conectar com a API.';
        console.error(error);
    }
});
