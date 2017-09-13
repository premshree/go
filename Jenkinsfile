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

sstkNode([ saveWorkspace: false ], 'build', [ alpineContainer ]) {
  // fetch the code and initialize the GitHub helper
  checkout scm

  g.initialize()

  s.initialize(fromGitHub(g))

  // execute all commands in the Build And Test container
  container(alpineContainer.getName()) {
    // execute build and test steps
    stage('build') {
        sh('go get && go build')
    }
  }

  s.sstkStage(type: 'buildImage', name: 'build docker image') {
      s.buildAndPublishImage([ noCache: true ])
  }
}