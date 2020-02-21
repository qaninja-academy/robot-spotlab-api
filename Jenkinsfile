pipeline {
    agent {
        docker {
            image "qaninja/pyrobot2"
        }
    }

    stages {
        stage("Preparation") {
            steps {
                sh "pip install --upgrade pip"
                sh "pip install -r requirements.txt --user"
            }
        }
        stage("Tests") {
            steps {
                sh "robot -d ./logs -i smoke tests"
            }
        }
    }
}
