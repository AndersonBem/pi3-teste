async function getDados() {
    const resultado = document.getElementById('resultado');

    try {
        const response = await fetch('http://127.0.0.1:7000/api/hello/');
        const data = await response.json();

        resultado.innerHTML = data.mensagem;
    } catch (error) {
        resultado.innerHTML = 'Erro ao conectar com a API.';
    }
}