
pipeline { 
    agent any  
    
    //jdk = tool name: 'JDK18'
   // env.JAVA_HOME = "${jdk}"

   // echo "jdk installation path is: ${jdk}"

  // next 2 are equivalents
   //  sh "${jdk}/bin/java -version"

  // note that simple quote strings are not evaluated by Groovy
  // substitution is done by shell script using environment
  //   sh '$JAVA_HOME/bin/java -version'
    
    stages { 
        stage('Build') { 
            steps { 
               echo 'This is a pipeline to build .war package.'
                //sh 'mvn --version'
                
                 withEnv(["JAVA_HOME=${ tool JDK18 }", "PATH+JAVA=${ tool JDK18}"]) {
                     
                
                withMaven(maven : 'Maven_3.3.9'){
                 sh 'mvn --version'
                 sh "bin/build"
                }
                     
           }
               // sh 'mvn clean package -U'
               //sh "bin/build"
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
                       app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        
       stage('Deploy To Production') {
         when {
                branch 'master'
           }
            steps {
                input 'Deploy to Production?'
                milestone(1)
              sshagent ( ['webserver_ssh_key']) {
                  script {
                    sh "ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull vgdocker123/javademo:${env.BUILD_NUMBER}\""
                        try {
                           sh "ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop javademo\""
                           sh "ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm javademo\""
                       } catch (err) {
                           echo: 'caught error: $err'
                    }
                       sh "ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name javademo -p 8080:8080 -d vgdocker123/javademo:${env.BUILD_NUMBER}\""
                   }
                }
           }
    }
       
        
     // Test on cloud Server
        
     // stage('DeployToProduction') {
       //     when {
       //         branch 'master'
        //    }
          //  steps {
           //     input 'Deploy to Production?'
            //    milestone(1)
             //   withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
              //      script {
              //          sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull vgdocker123/javademo:${env.BUILD_NUMBER}\""
               //         try {
               //             sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop javademo\""
               //             sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm javademo\""
             //           } catch (err) {
           //                 echo: 'caught error: $err'
       //                 }
        //                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name train-schedule -p 8080:8080 -d vgdocker123/javademo:${env.BUILD_NUMBER}\""
       //             }
       //         }
       //     }
    //    }
        
        
// close        
    }
}

