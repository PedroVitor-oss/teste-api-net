# Etapa 1: build da aplicação
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copia o arquivo .csproj e restaura as dependências
COPY *.csproj .
RUN dotnet restore

# Copia o resto do código e faz o build
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Etapa 2: imagem final (menor, só runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

# Copia os arquivos publicados da etapa de build
COPY --from=build /app/publish .

# Configura a porta que o Render espera
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["dotnet", "SeuProjeto.dll"]