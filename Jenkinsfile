pipeline {
    agent {
        docker {
            image "python"
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
                robot "logs"
            }
        }
    }
}
