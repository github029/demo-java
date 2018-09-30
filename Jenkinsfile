
pipeline { 
    agent any  
    stages { 
        stage('Build') { 
            steps { 
               echo 'This is a pipeline to build .war package.'
                sh 'mvn --version'
                sh 'mvn clean package -U'
                // prepare docker build context
                sh "cp target/demo.war ./tmp-docker-build-context"
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("veer/java-demo")
                    app.inside {
                        sh 'echo $(curl localhost:8080)'
                    }
                }
            }
        }


    }
}

