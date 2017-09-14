@Library('sstk-pipeline-plugin') _

import static com.shutterstock.Container.*
import static com.shutterstock.PipelineOptions.*

def s = sstk(this, 'pipeline', '2.0')
def g = sstk(this, 'github-utils')

def alpineContainer = fromDockerHub('golang:1.8-alpine')

// Set the debug level to warn (the default is info which is very verbose)
alpineContainer.useEnvVars([
  NPM_CONFIG_LOGLEVEL: 'warn'
])

sstkNode([ saveWorkspace: true, saveWorkspaceIncludes: "deployment/*" ], 'build', [ alpineContainer ]) {
  // fetch the code and initialize the GitHub helper
  checkout scm

  g.initialize()

  s.initialize(fromGitHub(g))

  // execute all commands in the Build And Test container
  container(alpineContainer.getName()) {
    // execute build and test steps
    stage('build') {
        sh('apk add --update git')
        sh('mkdir -p /go/src/github.shuttercorp.net/shutterstock/go-links')
        sh('cp -r $(pwd)/* /go/src/github.shuttercorp.net/shutterstock/go-links')
        sh('JENKINS_DIR="$(pwd)" && cd /go/src/github.shuttercorp.net/shutterstock/go-links && go get && go build && cp go-links $JENKINS_DIR')
    }
  }

  s.sstkStage(type: 'buildImage', name: 'build docker image') {
      s.buildAndPublishImage([ noCache: true ])
  }
}

sstkNode([:], 'dev', [ alpineContainer ]) {
    s.sstkStage(type: 'devDeploy', name: 'deploy') {
        String appFqdn = s.deployGenericHttp('deployment')
        appUrl = "http://${appFqdn}"
        s.awaitURLReadiness("${appUrl}/ready")
    }
}