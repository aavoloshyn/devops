pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                script {
                    sh 'echo "------------------START CHECKOUT------------------"'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'ssh-gihub', url: 
'git@github.com:aavoloshyn/devops.git']])
                    sh 'echo "------------------FINISH CHECKOUT------------------"'
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    sh 'echo "------------------START BUILD------------------"'
                    sh 'docker build -t ambidekstr/jenkins .'
                    sh 'echo "------------------FINISH BUILD------------------"'
                }
            }
        }
        
        stage('Push artifact') {
            steps {
                script {
                    sh 'echo "------------------START PUSH ARTIFACT------------------"'
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'psw', usernameVariable: 'usrname')]) {
                        sh "docker login -u ${env.usrname} -p ${env.psw}"
                        sh 'docker push ambidekstr/jenkins'
                    }
                    sh 'echo "------------------FINISH PUSH ARTIFACT------------------"'
                }
            }
        }
        stage('Deploy') {
            steps {
                
                script {
                    sh 'echo "------------------START DEPLOY------------------"'
                    sshPublisher(publishers: [sshPublisherDesc(configName: 'web-site', transfers: [sshTransfer(cleanRemote: false, excludes: '', 
                    execCommand: '''PREVIOUS_CONTAINER_ID=`docker ps -f "name=jenkins-add-demo" -aq`
                    docker stop "${PREVIOUS_CONTAINER_ID}" && docker rm "${PREVIOUS_CONTAINER_ID}" 
                    docker run -d --name jenkins-add-demo -p 8081:80 ambidekstr/jenkins ''', 
                    execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', 
                    remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, 
                    useWorkspaceInPromotion: false, verbose: false)])
                    sh 'echo "------------------FINISH DEPLOY------------------"'
                }
            }
        }
    }
}

