pipeline {
  agent { label 'delphi-qa' }

  options {
    timestamps()
    disableConcurrentBuilds()

    // Opcional (recomendado): evita acumular builds antigos no Jenkins
    // Mantém os últimos 20 builds (ajuste como quiser)
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    BDS      = 'C:\\DelphiCompiler\\23.0'
    CFG      = 'build.cfg'
    DPR      = 'Project1.dpr'
    OUT_EXE  = 'Win32\\Release\\Project1.exe'
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (dcc32)') {
      steps {
        bat """
          @echo on
          cd /d "%WORKSPACE%"

          rem --- toolchain ---
          call "%BDS%\\bin\\rsvars.bat"
          if errorlevel 1 exit /b 1

          rem --- evita executar EXE antigo (mascarar falha de build) ---
          if exist "%OUT_EXE%" del /q "%OUT_EXE%"

          rem --- valida arquivos esperados ---
          if not exist "%CFG%" (
            echo ERROR: %CFG% nao encontrado em %WORKSPACE%
            exit /b 1
          )
          if not exist "%DPR%" (
            echo ERROR: %DPR% nao encontrado em %WORKSPACE%
            exit /b 1
          )

          rem --- compila (saidas definidas no cfg) ---
          dcc32 @%CFG% %DPR%
          if errorlevel 1 exit /b 1

          rem --- confirma o EXE gerado ---
          if not exist "%OUT_EXE%" (
            echo ERROR: EXE nao foi gerado: %OUT_EXE%
            exit /b 1
          )

          dir "%OUT_EXE%"
        """
      }
    }

    stage('Run tests') {
      steps {
        bat """
          @echo on
          cd /d "%WORKSPACE%"

          "%OUT_EXE%"
          set RC=%ERRORLEVEL%
          echo ExitCode=%RC%
          exit /b %RC%
        """
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: '**\\Win32\\Release\\**\\*', fingerprint: true
      rem Workspace mantido (sem cleanWs)
    }
  }
}
