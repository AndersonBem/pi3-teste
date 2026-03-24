Write-Host "====================================="
Write-Host " Setup Django API + Frontend Separado"
Write-Host "====================================="

# 1) Criar pastas principais
Write-Host "`n[1/13] Criando estrutura base..."
New-Item -ItemType Directory -Force -Path ".\backend" | Out-Null
New-Item -ItemType Directory -Force -Path ".\frontend" | Out-Null

# =========================
# BACKEND (DJANGO API)
# =========================

Set-Location backend

# 2) Criar ambiente virtual
Write-Host "[2/13] Criando ambiente virtual..."
python -m venv venv

# 3) Ativar ambiente virtual
Write-Host "[3/13] Ativando ambiente virtual..."
& .\venv\Scripts\Activate.ps1

# 4) Atualizar pip
Write-Host "[4/13] Atualizando pip..."
python -m pip install --upgrade pip

# 5) Instalar dependências
Write-Host "[5/13] Instalando dependências..."
pip install django djangorestframework django-cors-headers

# 6) Criar projeto Django
Write-Host "[6/13] Criando projeto Django..."
django-admin startproject config .

# 7) Criar app api
Write-Host "[7/13] Criando app api..."
python manage.py startapp api

# 8) Gerar requirements.txt
Write-Host "[8/13] Gerando requirements.txt..."
pip freeze > requirements.txt

# 9) Configurar settings.py
Write-Host "[9/13] Configurando settings.py..."

$settingsPath = ".\config\settings.py"
$settingsContent = Get-Content $settingsPath -Raw

$settingsContent = $settingsContent -replace "INSTALLED_APPS = \[", "INSTALLED_APPS = [`r`n    'corsheaders',`r`n    'rest_framework',`r`n    'api',"
$settingsContent = $settingsContent -replace "MIDDLEWARE = \[", "MIDDLEWARE = [`r`n    'corsheaders.middleware.CorsMiddleware',"
$settingsContent = $settingsContent -replace "ALLOWED_HOSTS = \[\]", "ALLOWED_HOSTS = ['127.0.0.1', 'localhost']"

$settingsContent += @"

CORS_ALLOWED_ORIGIN_REGEXES = [
    r"^http://127\.0\.0\.1:\d+$",
    r"^http://localhost:\d+$",
]


CORS_ALLOW_CREDENTIALS = True
"@

Set-Content $settingsPath $settingsContent

# 10) Criar API básica
Write-Host "[10/13] Criando endpoint inicial da API..."

$viewsContent = @"
from rest_framework.response import Response
from rest_framework.decorators import api_view


@api_view(['GET'])
def hello_world(request):
    return Response({'mensagem': 'Olá, mundo!'})
"@

Set-Content ".\api\views.py" $viewsContent

$apiUrlsContent = @"
from django.urls import path
from .views import hello_world

urlpatterns = [
    path('hello/', hello_world, name='hello_world'),
]
"@

Set-Content ".\api\urls.py" $apiUrlsContent

$configUrlsContent = @"
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('api.urls')),
]
"@

Set-Content ".\config\urls.py" $configUrlsContent

Set-Location ..

# =========================
# FRONTEND (HTML/CSS/JS)
# =========================

Set-Location frontend

# 11) Criar estrutura frontend
Write-Host "[11/13] Criando estrutura do frontend..."
New-Item -ItemType Directory -Force -Path ".\css" | Out-Null
New-Item -ItemType Directory -Force -Path ".\js" | Out-Null
New-Item -ItemType Directory -Force -Path ".\assets" | Out-Null

$indexContent = @"
<!DOCTYPE html>
<html lang='pt-br'>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>Frontend Inicial</title>
    <link rel='stylesheet' href='./css/style.css'>
</head>
<body>
    <main class='container'>
        <h1>Frontend separado</h1>
        <p>Exemplo inicial consumindo a API Django.</p>
        <button id='btn'>Buscar mensagem</button>
        <p id='resultado'>Clique no botão para testar.</p>
    </main>

    <script src='./js/script.js'></script>
</body>
</html>
"@

Set-Content ".\index.html" $indexContent

$styleContent = @"
body {
    font-family: Arial, Helvetica, sans-serif;
    margin: 0;
    padding: 40px;
    background: #f5f5f5;
    color: #222;
}

.container {
    max-width: 700px;
    margin: 0 auto;
    background: #fff;
    padding: 24px;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

button {
    padding: 10px 16px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
}

#resultado {
    margin-top: 16px;
    font-weight: bold;
}
"@

Set-Content ".\css\style.css" $styleContent

$scriptContent = @"
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
"@

Set-Content ".\js\script.js" $scriptContent

Set-Location ..

# =========================
# README + INSTRUCOES
# =========================

# 12) README.md
Write-Host "[12/13] Criando README.md..."

$readme = @"
# Projeto com backend e frontend separados

## Estrutura

- backend -> projeto Django API
- frontend -> HTML, CSS e JavaScript puro

## Objetivo

Este projeto foi preparado para trabalhar com:

- Django como API
- frontend separado
- consumo da API via fetch
- banco de dados a ser definido pela equipe depois

## Observação

O projeto foi iniciado com um endpoint simples de teste para facilitar o começo do desenvolvimento.
"@

Set-Content ".\README.md" $readme

# 13) instrucoes.txt
Write-Host "[13/13] Criando instrucoes.txt..."

$instrucoes = @"
INSTRUCOES DO PROJETO

1. GITIGNORE
Antes de subir o projeto corretamente no GitHub, gerar um .gitignore no site:
https://www.toptal.com/developers/gitignore
Sugestão de busca no site:
Python, Django, VisualStudioCode

2. ESTRUTURA DO PROJETO
A pasta backend contém a API em Django.
A pasta frontend contém o front separado com HTML, CSS e JavaScript.

3. QUANDO OUTRA PESSOA BAIXAR O PROJETO DO GITHUB
Cada integrante precisa criar a própria venv localmente dentro da pasta backend.

Exemplo no PowerShell:
cd backend
python -m venv venv

4. ATIVAR A VENV
No PowerShell:
.\venv\Scripts\Activate.ps1

5. INSTALAR AS DEPENDENCIAS
Ainda dentro da pasta backend:
pip install -r requirements.txt

6. BANCO DE DADOS
O banco de dados real ainda será definido/configurado pela equipe.
Antes de começar o desenvolvimento das funcionalidades principais, será necessário:

- escolher o banco que será usado
- criar o banco
- configurar as credenciais no projeto
- ajustar settings.py ou usar variáveis de ambiente
- definir como será o fluxo de criação das tabelas

7. RODAR O BACKEND
Depois que o ambiente estiver configurado, o backend pode ser iniciado com:
python manage.py runserver 7000

8. RODAR O FRONTEND
A pasta frontend pode ser aberta com Live Server no VS Code, ou outra forma de servidor local.

9. TESTE INICIAL DA API
Existe um endpoint inicial para teste:
http://127.0.0.1:7000/api/hello/

10. OBJETIVO DO FRONTEND INICIAL
O frontend criado serve apenas como ponto de partida para a equipe entender:
- como separar front e back
- como fazer requisição para a API
- como mostrar a resposta na tela

11. PROXIMOS PASSOS RECOMENDADOS
- definir o banco de dados oficial do projeto
- modelar as tabelas
- configurar ambiente com variáveis
- definir os endpoints principais
- começar as telas e regras do sistema
"@

Set-Content ".\instrucoes.txt" $instrucoes

Write-Host "`n====================================="
Write-Host " Setup finalizado com sucesso!"
Write-Host "====================================="
Write-Host ""
Write-Host "Estrutura criada:"
Write-Host "  backend -> Django API"
Write-Host "  frontend -> HTML/CSS/JS"
Write-Host ""
Write-Host "Endpoint inicial:"
Write-Host "  http://127.0.0.1:7000/api/hello/"