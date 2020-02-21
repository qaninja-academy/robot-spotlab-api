pipeline {
    agent {
        docker {
            image "python:3.7.6-stretch"
        }
    }

    stages {
        stage("Preparation") {
            steps {
                sh "pip install -r requirements.txt"
            }
        }
        stage("Tests") {
            steps {
                sh "robot -d ./logs -i smoke tests"
            }
        }
    }
}
