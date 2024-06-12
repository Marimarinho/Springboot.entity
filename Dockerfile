# Etapa 1: Construir o JAR usando Maven
# Usar uma imagem base oficial do Maven para construir o JAR
FROM maven:3.8.6-eclipse-temurin-17 AS build

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o arquivo pom.xml e as dependências do projeto para o cache de construção
COPY pom.xml .
COPY src ./src

# Rodar o comando de construção do Maven para criar o JAR
RUN mvn clean package -DskipTests

# Etapa 2: Criar a imagem de execução
# Usar uma imagem base oficial do OpenJDK
FROM eclipse-temurin:17-jdk-alpine

# Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copiar o arquivo JAR gerado para o diretório de trabalho do contêiner
COPY --from=build /app/target/*.jar app.jar

# Expor a porta que a aplicação Spring Boot está configurada para escutar
EXPOSE 8080

# Definir o comando padrão para executar o JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
