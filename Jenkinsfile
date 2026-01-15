pipeline {
  agent { label 'delphi-qa' }

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    BDS      = 'C:\\DelphiCompiler\\23.0'
    CFG      = 'build.cfg'
    DPR      = 'Project1.dpr'
    OUT_EXE  = 'Win32\\Release\\Project1.exe'
    LOG_DIR  = '_ci'
    LOG_FILE = '_ci\\test-output.log'
    // Se seu runner suportar JUnit, use um desses nomes:
    JUNIT_XML = '_ci\\test-results.xml'
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

          if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

          call "%BDS%\\bin\\rsvars.bat"
          if errorlevel 1 exit /b 1

          rem Evita rodar binario antigo
          if exist "%OUT_EXE%" del /q "%OUT_EXE%"

          if not exist "%CFG%" (
            echo ERROR: %CFG% nao encontrado em %WORKSPACE%
            exit /b 1
          )
          if not exist "%DPR%" (
            echo ERROR: %DPR% nao encontrado em %WORKSPACE%
            exit /b 1
          )

          dcc32 @%CFG% %DPR%
          if errorlevel 1 exit /b 1

          if not exist "%OUT_EXE%" (
            echo ERROR: EXE nao foi gerado: %OUT_EXE%
            exit /b 1
          )
        """
      }
    }

    stage('Run tests') {
      steps {
        bat """
          @echo on
          cd /d "%WORKSPACE%"

          if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

          rem Limpa log anterior
          if exist "%LOG_FILE%" del /q "%LOG_FILE%"

          rem Executa e captura stdout/stderr em log
          "%OUT_EXE%" > "%LOG_FILE%" 2>&1
          set RC=%ERRORLEVEL%

          rem Mostra o log no console do Jenkins (para facilitar debug)
          type "%LOG_FILE%"

          echo ExitCode=%RC%
          exit /b %RC%
        """
      }
    }

    // Opcional: se você conseguir gerar JUnit XML, o Jenkins publica aqui
    stage('Publish test results (JUnit)') {
      steps {
        script {
          // Não falha o build se o xml não existir (deixe opcional)
        }
        bat """
          @echo on
          cd /d "%WORKSPACE%"
          if exist "%JUNIT_XML%" (
            echo Found JUnit: %JUNIT_XML%
          ) else (
            echo JUnit XML nao encontrado (ok se ainda nao configurado): %JUNIT_XML%
          )
        """
      }
      post {
        always {
          // Publica se existir; se não existir, não quebra o build
          junit allowEmptyResults: true, testResults: '_ci\\*.xml'
        }
      }
    }
  }

  post {
    always {
      // Arquiva binário + logs + qualquer xml que existir
      archiveArtifacts artifacts: '''
        Win32\\Release\\**\\*.exe,
        Win32\\Release\\**\\*.dll,
        Win32\\Release\\**\\*.bpl,
        _ci\\**\\*.log,
        _ci\\**\\*.xml
      ''', fingerprint: true

      // Mantém o workspace sempre limpo
      cleanWs(deleteDirs: true, disableDeferredWipeout: true)
    }
  }
}
