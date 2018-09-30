
pipeline { 
    agent any  
    stages { 
        stage('Build') { 
            steps { 
               echo 'This is a pipeline to build .war package.'
                sh 'mvn --version'
               // sh 'mvn clean package -U'
               sh "bin/build"
                // prepare docker build context
               //sh 'sudo chmod 777 /var/lib/docker/tmp'
               // sh "cp target/demo.war /var/lib/docker/tmp"
            }
        }

        stage('Build Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    app = docker.build("veer/java-demo .")
                    app.inside {
                        sh 'echo $(curl 107.21.35.45:8080/demo/Hello)'
                    }
                }
            }
        }


    }
}

