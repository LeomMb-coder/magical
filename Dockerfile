# 1. Use uma imagem oficial do Python como imagem base.
# A imagem 'slim' é uma boa escolha para manter o tamanho final da imagem menor.
# O readme menciona Python 3.10+, então 3.11-slim é uma escolha segura e moderna.
FROM python:3.11-slim

# 2. Define o diretório de trabalho no contêiner
WORKDIR /app

# 3. Copia o arquivo de dependências para o diretório de trabalho
# Isso é feito primeiro para aproveitar o cache de camadas do Docker.
# Se o requirements.txt não mudar, esta camada não será reconstruída.
COPY requirements.txt .

# 4. Instala os pacotes necessários definidos no requirements.txt
# --no-cache-dir reduz o tamanho da imagem.
# --upgrade pip garante que temos a versão mais recente.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. Copia o restante do código da aplicação para o contêiner
COPY . .

# 6. Expõe a porta em que o aplicativo é executado
EXPOSE 8000

# 7. Define o comando para executar o aplicativo
# Usa uvicorn para rodar a aplicação FastAPI.
# --host 0.0.0.0 torna o aplicativo acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]