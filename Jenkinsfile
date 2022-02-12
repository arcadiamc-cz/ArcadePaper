pipeline {
  agent any

  tools {
    jdk '1.8.0_292'
  }

  environment {
    DISCORD_WEBHOOK_URL = credentials('discord-webhook-url')
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

    stage('Javadoc') {
      steps {
        sh 'mvn -Dmaven.test.skip=true -f ArcadePaper-API javadoc:javadoc -DadditionalJOption=-Xdoclint:none'
        javadoc(javadocDir: 'ArcadePaper-API/target/site/apidocs', keepAll: true)
      }
    }
  }

  post {
    always {
      discordSend image: "${env.JENKINS_URL}/userContent/banner.png", description: "Build completed with status: **${currentBuild.currentResult}**", footer: "", link: env.BUILD_URL, result: currentBuild.currentResult, title: "Build ${env.JOB_NAME} #${env.BUILD_NUMBER}", webhookURL: "${DISCORD_WEBHOOK_URL}"
    }
  }
}
