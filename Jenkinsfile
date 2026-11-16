cat > Jenkinsfile <<'EOF'
pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git rev-parse --short HEAD'
            }
        }

        stage('Tests Maven') {
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw -B test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t spring-petclinic:multi-stage .'
            }
        }

        stage('Verify Docker Image') {
            steps {
                sh 'docker image inspect spring-petclinic:multi-stage'
            }
        }
    }
}
EOF
