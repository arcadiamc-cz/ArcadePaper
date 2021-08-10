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
            archiveArtifacts 'ArcadePaper-Server/target/arcadepaper-1.8.8-R0.1-SNAPSHOT.jar'
          }
        }

        stage('Repository') {
          steps {
            configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS_XML')]) {
              sh 'mvn -Dmaven.test.skip=true -s $MAVEN_SETTINGS_XML --projects cz.arcadiamc:arcadepaper-api,cz.arcadiamc:arcadepaper-parent deploy'
            }
          }
        }
      }
    }
  }
}