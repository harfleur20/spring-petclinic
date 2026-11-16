# Étape 1 : construction de l'application
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /workspace

# Copier les fichiers nécessaires à Maven
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Rendre le wrapper exécutable et télécharger les dépendances
RUN chmod +x mvnw && ./mvnw -B dependency:go-offline

# Copier le code source
COPY src/ src/

# Construire le JAR sans réexécuter les tests
RUN ./mvnw -B -DskipTests package


# Étape 2 : exécution de l'application
FROM eclipse-temurin:17-jre-jammy AS runtime

WORKDIR /app

# Copier uniquement le JAR produit par la construction
COPY --from=build --chown=10001:0 /workspace/target/*.jar /app/app.jar

# Exécuter l'application sans privilèges root
USER 10001:0

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
