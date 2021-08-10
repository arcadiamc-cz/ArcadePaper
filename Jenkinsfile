pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh './arcadepaper build'
      }
    }

    stage('Deployment') {
      parallel {
        stage('Artifact') {
          steps {
            archiveArtifacts 'ArcadePaper-Server/arcadepaper-1.8.8-R0.1-SNAPSHOT.jar'
          }
        }

        stage('Repository') {
          steps {
            sh '''mvn -Dmaven.test.skip=true --projects cz.arcadiamc:arcadepaper-api,cz.arcadiamc:arcadepaper-parent deploy
'''
          }
        }

      }
    }

  }
}