pipeline {
    agent any

    tools {
        jdk '1.8.0_292'
    }
  
    stages {
        stage('Build') {
            steps {
                sh './arcadepaper build'
                sh './arcadepaper paperclip'
            }

            post {
                success {
                    archiveArtifacts artifacts: 'arcade-paperclip.jar', fingerprint: true
                }
            }
        }

        stage('Deploy') {
            when {
                branch "main"
            }

            steps {
                configFileProvider([configFile(fileId: 'maven-settings', variable: 'MAVEN_SETTINGS_XML')]) {
                    sh 'mvn -Dmaven.test.skip=true -s $MAVEN_SETTINGS_XML -P public --projects cz.arcadiamc:arcadepaper-api,cz.arcadiamc:arcadepaper-parent deploy'
                    sh 'mvn -Dmaven.test.skip=true -s $MAVEN_SETTINGS_XML -P internal --projects cz.arcadiamc:arcadepaper deploy'
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
            script {
                def changeLogSets = currentBuild.changeSets
                def message = "**Changes:**"

                if (changeLogSets.size() == 0) {
                    message += "\n*No changes.*"
                } else {
                    def repositoryUrl = scm.userRemoteConfigs[0].url.replace(".git", "")
                    def count = 0;
                    def extra = 0;
                    for (int i = 0; i < changeLogSets.size(); i++) {
                        def entries = changeLogSets[i].items
                        for (int j = 0; j < entries.length; j++) {
                            if (count <= 10) {
                                def entry = entries[j]
                                def commitId = entry.commitId.substring(0, 6)
                                message += "\n   - [`${commitId}`](${repositoryUrl}/commit/${entry.commitId}) ${entry.msg}"
                                count++
                            } else {
                                extra++;
                            }
                        }
                    }

                    if (extra != 0) {
                        message += "\n   - ${extra} more commits"
                    }
                }

                env.changes = message
            }

            withCredentials([string(credentialsId: 'discord-webhook-url', variable: 'DISCORD_WEBHOOK')]) {
                discordSend description: "**Build:** [${currentBuild.id}](${env.BUILD_URL})\n**Status:** [${currentBuild.currentResult}](${env.BUILD_URL})\n${changes}\n\n[**Artifacts on Jenkins**](https://ci.arcadiamc.cz/job/arcadepaper/job/main/)", footer: 'ArcadiaMC Jenkins', link: env.BUILD_URL, result: currentBuild.currentResult, title: "${env.JOB_NAME} #${currentBuild.id}", webhookURL: DISCORD_WEBHOOK
            }
        }
    }
}
