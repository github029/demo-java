
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
                    app = docker.build("vgdocker123/javademo")
                    app.inside {
                        sh 'echo $(curl 107.21.35.45:8080/demo/Hello)'
                    }
                }
            }
        }

        
      stage('Push Docker Image') {
            when {
                branch 'master'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com/', 'docker_hub_login') {
                       // app.push("vgdocker123/test1")
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        
        

    }
}

