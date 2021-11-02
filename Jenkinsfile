pipeline {
  agent any
  
  tools {
    jdk '1.8.0_292'
  }
  
  stages {
    stage('Build') {
      steps {
        sh './arcadepaper build'
      }
    }

    stage('Paperclip') {
      steps {
        sh './arcadepaper paperclip'
      }
    }

    stage('Deployment') {
      parallel {
        stage('Artifact') {
          steps {
            archiveArtifacts 'arcadepaperclip.jar'
          }
        }

        stage('Repository') {
          steps {
            configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS_XML')]) {
              sh 'mvn -Dmaven.test.skip=true -s $MAVEN_SETTINGS_XML -P public --projects cz.arcadiamc:arcadepaper-api,cz.arcadiamc:arcadepaper-parent deploy'
              sh 'mvn -Dmaven.test.skip=true -s $MAVEN_SETTINGS_XML -P internal --projects cz.arcadiamc:arcadepaper deploy'
            }
          }
        }
      }
    }
  }
}
